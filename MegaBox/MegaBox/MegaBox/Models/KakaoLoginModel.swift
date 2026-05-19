import Foundation
import AuthenticationServices
import Alamofire
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
        if status != errSecSuccess {
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

    static var callbackScheme: String? {
        URL(string: redirectURI)?.scheme
    }

    static var isConfigured: Bool {
        !restAPIKey.isEmpty &&
        !redirectURI.isEmpty &&
        !restAPIKey.contains("YOUR_") &&
        !redirectURI.contains("YOUR_")
    }
}

final class KakaoLoginService: NSObject {
    static let shared = KakaoLoginService()

    private var authenticationSession: ASWebAuthenticationSession?
    private var continuation: CheckedContinuation<String, Error>?

    func login() async throws -> KakaoLoginResult {
        guard KakaoLoginConfiguration.isConfigured else {
            throw KakaoLoginError.missingConfiguration
        }

        let authorizationCode = try await requestAuthorizationCode()
        let tokenInfo = try await requestToken(with: authorizationCode)
        let userInfo = try await requestUserInfo(accessToken: tokenInfo.accessToken)

        return KakaoLoginResult(
            tokenInfo: tokenInfo,
            userID: String(userInfo.id),
            userName: userInfo.kakaoAccount?.profile?.nickname ?? "카카오 사용자"
        )
    }

    private func requestAuthorizationCode() async throws -> String {
        let state = UUID().uuidString
        guard var components = URLComponents(string: "https://kauth.kakao.com/oauth/authorize") else {
            throw KakaoLoginError.invalidAuthorizeURL
        }

        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: KakaoLoginConfiguration.restAPIKey),
            URLQueryItem(name: "redirect_uri", value: KakaoLoginConfiguration.redirectURI),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "prompt", value: "login")
        ]

        guard let url = components.url, let callbackScheme = KakaoLoginConfiguration.callbackScheme else {
            throw KakaoLoginError.invalidAuthorizeURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme) { callbackURL, error in
                if let error {
                    continuation.resume(throwing: KakaoLoginError.authenticationFailed(error.localizedDescription))
                    self.continuation = nil
                    return
                }

                guard let callbackURL, let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false) else {
                    continuation.resume(throwing: KakaoLoginError.invalidCallbackURL)
                    self.continuation = nil
                    return
                }

                if let errorValue = components.queryItems?.first(where: { $0.name == "error" })?.value {
                    let description = components.queryItems?.first(where: { $0.name == "error_description" })?.value
                    continuation.resume(throwing: KakaoLoginError.kakaoError(errorValue, description ?? ""))
                    self.continuation = nil
                    return
                }

                guard let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                    continuation.resume(throwing: KakaoLoginError.authorizationCodeMissing)
                    self.continuation = nil
                    return
                }

                continuation.resume(returning: code)
                self.continuation = nil
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false
            self.authenticationSession = session
            session.start()
        }
    }

    private func requestToken(with authorizationCode: String) async throws -> KakaoTokenInfo {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8"
        ]

        var parameters: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": KakaoLoginConfiguration.restAPIKey,
            "redirect_uri": KakaoLoginConfiguration.redirectURI,
            "code": authorizationCode
        ]

        if !KakaoLoginConfiguration.clientSecret.isEmpty,
           !KakaoLoginConfiguration.clientSecret.contains("YOUR_") {
            parameters["client_secret"] = KakaoLoginConfiguration.clientSecret
        }

        do {
            let response = try await AF.request(
                "https://kauth.kakao.com/oauth/token",
                method: .post,
                parameters: parameters,
                encoder: URLEncodedFormParameterEncoder.default,
                headers: headers
            )
            .validate()
            .serializingDecodable(KakaoTokenResponseDTO.self)
            .value

            return response.toTokenInfo()
        } catch {
            print("카카오 토큰 요청 실패: \(error)")
            throw KakaoLoginError.tokenRequestFailed(error.localizedDescription)
        }
    }

    private func requestUserInfo(accessToken: String) async throws -> KakaoUserResponseDTO {
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
            print("카카오 사용자 정보 요청 실패: \(error)")
            throw KakaoLoginError.userInfoRequestFailed(error.localizedDescription)
        }
    }
}

extension KakaoLoginService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

struct KakaoTokenResponseDTO: Decodable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String?
    let expiresIn: Int
    let refreshTokenExpiresIn: Int?
    let scope: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
        case scope
    }

    func toTokenInfo() -> KakaoTokenInfo {
        KakaoTokenInfo(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType,
            expiresIn: expiresIn,
            refreshTokenExpiresIn: refreshTokenExpiresIn,
            scope: scope
        )
    }
}

struct KakaoUserResponseDTO: Decodable {
    let id: Int64
    let kakaoAccount: KakaoAccountDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case kakaoAccount = "kakao_account"
    }
}

struct KakaoAccountDTO: Decodable {
    let profile: KakaoProfileDTO?
}

struct KakaoProfileDTO: Decodable {
    let nickname: String?
}

enum KakaoLoginError: LocalizedError {
    case missingConfiguration
    case invalidAuthorizeURL
    case invalidCallbackURL
    case authorizationCodeMissing
    case authenticationFailed(String)
    case kakaoError(String, String)
    case tokenRequestFailed(String)
    case userInfoRequestFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingConfiguration:
            return "카카오 로그인 설정값이 비어 있습니다. REST API Key, Client Secret, Redirect URI를 확인해주세요."
        case .invalidAuthorizeURL:
            return "카카오 로그인 URL 생성에 실패했습니다."
        case .invalidCallbackURL:
            return "카카오 로그인 콜백 URL을 확인하지 못했습니다."
        case .authorizationCodeMissing:
            return "카카오 인가 코드가 없습니다."
        case .authenticationFailed(let message):
            return "카카오 인증에 실패했습니다: \(message)"
        case .kakaoError(let code, let description):
            return "카카오 로그인 오류(\(code)): \(description)"
        case .tokenRequestFailed(let message):
            return "카카오 토큰 요청에 실패했습니다: \(message)"
        case .userInfoRequestFailed(let message):
            return "카카오 사용자 정보 요청에 실패했습니다: \(message)"
        }
    }
}
