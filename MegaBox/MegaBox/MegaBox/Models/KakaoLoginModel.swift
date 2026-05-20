import Foundation
import Alamofire
import AuthenticationServices
import Security
import UIKit

struct KakaoTokenInfo: Codable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String
    let expiresIn: Int
    let refreshTokenExpiresIn: Int?
    let scope: String?
}

final class KakaoTokenService {
    static let shared = KakaoTokenService()

    private init() {}

    private let account = "kakaoToken"
    private let service = "com.megabox.kakaoTokenInfo"

    @discardableResult
    private func saveTokenInfo(_ tokenInfo: KakaoTokenInfo) -> OSStatus {
        do {
            let data = try JSONEncoder().encode(tokenInfo)

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecAttrService as String: service,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]

            SecItemDelete(query as CFDictionary)
            return SecItemAdd(query as CFDictionary, nil)
        } catch {
            print("카카오 토큰 JSON 인코딩 실패: \(error)")
            return errSecParam
        }
    }

    private func loadTokenInfo() -> KakaoTokenInfo? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess, let data = item as? Data else {
            print("카카오 토큰 불러오기 실패 - status: \(status)")
            return nil
        }

        do {
            return try JSONDecoder().decode(KakaoTokenInfo.self, from: data)
        } catch {
            print("카카오 토큰 JSON 디코딩 실패: \(error)")
            return nil
        }
    }

    @discardableResult
    private func deleteTokenInfo() -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]

        return SecItemDelete(query as CFDictionary)
    }

    @discardableResult
    func saveToken(_ tokenInfo: KakaoTokenInfo) -> Bool {
        let status = saveTokenInfo(tokenInfo)
        if status == errSecSuccess {
            print("카카오 토큰 키체인 저장 성공")
        } else {
            print("카카오 토큰 저장 실패 - status: \(status)")
        }
        return status == errSecSuccess
    }

    func loadToken() -> KakaoTokenInfo? {
        loadTokenInfo()
    }

    @discardableResult
    func deleteToken() -> Bool {
        let status = deleteTokenInfo()
        if status != errSecSuccess && status != errSecItemNotFound {
            print("카카오 토큰 삭제 실패 - status: \(status)")
        }
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

struct KakaoLoginResult {
    let tokenInfo: KakaoTokenInfo
    let userID: String
    let userName: String
}

enum KakaoLoginConfiguration {
    static var restAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "KakaoRestAPIKey") as? String ?? ""
    }

    static var clientSecret: String {
        Bundle.main.object(forInfoDictionaryKey: "KakaoClientSecret") as? String ?? ""
    }

    static var redirectURI: String {
        Bundle.main.object(forInfoDictionaryKey: "KakaoRedirectURI") as? String ?? ""
    }

    static var callbackURLScheme: String? {
        URL(string: redirectURI)?.scheme
    }

    static var isConfigured: Bool {
        !restAPIKey.isEmpty
        && !restAPIKey.contains("YOUR_")
        && !redirectURI.isEmpty
        && callbackURLScheme != nil
    }
}

final class KakaoLoginService: NSObject, ASWebAuthenticationPresentationContextProviding {
    static let shared = KakaoLoginService()

    private var webAuthenticationSession: ASWebAuthenticationSession?

    private override init() {}

    @MainActor
    func login() async throws -> KakaoLoginResult {
        guard KakaoLoginConfiguration.isConfigured else {
            throw KakaoLoginError.missingConfiguration
        }

        let authorizationCode = try await requestAuthorizationCode()
        let token = try await requestToken(code: authorizationCode)
        let user = try await requestCurrentUser(accessToken: token.accessToken)

        let tokenInfo = KakaoTokenInfo(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken,
            tokenType: token.tokenType,
            expiresIn: token.expiresIn,
            refreshTokenExpiresIn: token.refreshTokenExpiresIn,
            scope: token.scope
        )

        let userName = user.kakaoAccount?.profile?.nickname
            ?? user.properties?.nickname
            ?? "카카오 사용자"

        return KakaoLoginResult(
            tokenInfo: tokenInfo,
            userID: String(user.id),
            userName: userName
        )
    }

    @MainActor
    private func requestAuthorizationCode() async throws -> String {
        guard let authorizationURL = makeAuthorizationURL(),
              let callbackURLScheme = KakaoLoginConfiguration.callbackURLScheme else {
            throw KakaoLoginError.invalidAuthorizationURL
        }

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            let session = ASWebAuthenticationSession(
                url: authorizationURL,
                callbackURLScheme: callbackURLScheme
            ) { callbackURL, error in
                if let error {
                    continuation.resume(throwing: KakaoLoginError.authenticationFailed(error.localizedDescription))
                    return
                }

                guard let callbackURL else {
                    continuation.resume(throwing: KakaoLoginError.authorizationCodeMissing)
                    return
                }

                do {
                    let code = try self.parseAuthorizationCode(from: callbackURL)
                    continuation.resume(returning: code)
                } catch {
                    continuation.resume(throwing: error)
                }
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            self.webAuthenticationSession = session

            if !session.start() {
                continuation.resume(throwing: KakaoLoginError.authenticationFailed("인증 세션을 시작하지 못했습니다."))
            }
        }
    }

    private func requestToken(code: String) async throws -> KakaoTokenResponseDTO {
        var parameters: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": KakaoLoginConfiguration.restAPIKey,
            "redirect_uri": KakaoLoginConfiguration.redirectURI,
            "code": code
        ]

        if !KakaoLoginConfiguration.clientSecret.isEmpty {
            parameters["client_secret"] = KakaoLoginConfiguration.clientSecret
        }

        do {
            return try await AF.request(
                "https://kauth.kakao.com/oauth/token",
                method: .post,
                parameters: parameters,
                encoder: URLEncodedFormParameterEncoder.default
            )
            .validate()
            .serializingDecodable(KakaoTokenResponseDTO.self)
            .value
        } catch {
            throw KakaoLoginError.tokenRequestFailed(error.localizedDescription)
        }
    }

    private func requestCurrentUser(accessToken: String) async throws -> KakaoUserResponseDTO {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        do {
            return try await AF.request(
                "https://kapi.kakao.com/v2/user/me",
                method: .get,
                headers: headers
            )
            .validate()
            .serializingDecodable(KakaoUserResponseDTO.self)
            .value
        } catch {
            throw KakaoLoginError.userInfoRequestFailed(error.localizedDescription)
        }
    }

    private func makeAuthorizationURL() -> URL? {
        var components = URLComponents(string: "https://kauth.kakao.com/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: KakaoLoginConfiguration.restAPIKey),
            URLQueryItem(name: "redirect_uri", value: KakaoLoginConfiguration.redirectURI)
        ]
        return components?.url
    }

    private func parseAuthorizationCode(from url: URL) throws -> String {
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems

        if let error = queryItems?.first(where: { $0.name == "error" })?.value {
            let description = queryItems?.first(where: { $0.name == "error_description" })?.value
            throw KakaoLoginError.authenticationFailed(description ?? error)
        }

        guard let code = queryItems?.first(where: { $0.name == "code" })?.value,
              !code.isEmpty else {
            throw KakaoLoginError.authorizationCodeMissing
        }

        return code
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow } ?? UIWindow(frame: .zero)
    }
}

enum KakaoLoginError: LocalizedError {
    case missingConfiguration
    case invalidAuthorizationURL
    case authenticationFailed(String)
    case authorizationCodeMissing
    case tokenRequestFailed(String)
    case tokenMissing
    case userInfoMissing
    case userInfoRequestFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingConfiguration:
            return "카카오 REST API 설정값이 비어 있습니다. REST API 키와 Redirect URI를 확인해주세요."
        case .invalidAuthorizationURL:
            return "카카오 인증 URL을 만들 수 없습니다. Redirect URI 형식을 확인해주세요."
        case .authenticationFailed(let message):
            return "카카오 인증에 실패했습니다: \(message)"
        case .authorizationCodeMissing:
            return "카카오 인증 코드를 받지 못했습니다."
        case .tokenRequestFailed(let message):
            return "카카오 토큰 요청에 실패했습니다: \(message)"
        case .tokenMissing:
            return "카카오 토큰을 받지 못했습니다."
        case .userInfoMissing:
            return "카카오 사용자 정보를 받지 못했습니다."
        case .userInfoRequestFailed(let message):
            return "카카오 사용자 정보 요청에 실패했습니다: \(message)"
        }
    }
}

private struct KakaoTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String
    let expiresIn: Int
    let refreshTokenExpiresIn: Int?
    let scope: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
        case scope
    }
}

private struct KakaoUserResponseDTO: Decodable {
    let id: Int64
    let properties: KakaoUserPropertiesDTO?
    let kakaoAccount: KakaoAccountDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case properties
        case kakaoAccount = "kakao_account"
    }
}

private struct KakaoUserPropertiesDTO: Decodable {
    let nickname: String?
}

private struct KakaoAccountDTO: Decodable {
    let profile: KakaoProfileDTO?
}

private struct KakaoProfileDTO: Decodable {
    let nickname: String?
}
