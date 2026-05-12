import Alamofire
import Foundation

struct KakaoLoginResult: Sendable {
    let tokenInfo: TokenInfo
    let user: KakaoUserResponse
}

@MainActor
final class KakaoAuthService {
    static let shared = KakaoAuthService()

    private let webAuthSession: KakaoWebAuthSession

    init(webAuthSession: KakaoWebAuthSession) {
        self.webAuthSession = webAuthSession
    }

    convenience init() {
        self.init(webAuthSession: KakaoWebAuthSession())
    }

    func login() async throws -> KakaoLoginResult {
        let authURL = try makeAuthorizationURL()
        let callbackURL = try await webAuthSession.start(
            url: authURL,
            redirectURI: Config.kakaoRedirectURI
        )
        let code = try extractAuthorizationCode(from: callbackURL)
        let token = try await requestToken(code: code)
        let user = try await requestUser(accessToken: token.accessToken)
        return KakaoLoginResult(tokenInfo: token.tokenInfo, user: user)
    }

    private func makeAuthorizationURL() throws -> URL {
        var components = URLComponents(string: "https://kauth.kakao.com/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Config.kakaoRestAPIKey),
            URLQueryItem(name: "redirect_uri", value: Config.kakaoRedirectURI)
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        return url
    }

    private func extractAuthorizationCode(from callbackURL: URL) throws -> String {
        guard let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidResponse
        }

        if let error = components.queryItems?.first(where: { $0.name == "error" })?.value {
            throw APIError.configuration("카카오 로그인 실패: \(error)")
        }

        guard let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
              !code.isEmpty else {
            throw APIError.missingAuthorizationCode
        }
        return code
    }

    private func requestToken(code: String) async throws -> KakaoTokenResponse {
        var parameters: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": Config.kakaoRestAPIKey,
            "redirect_uri": Config.kakaoRedirectURI,
            "code": code
        ]

        if let clientSecret = Config.kakaoClientSecret {
            parameters["client_secret"] = clientSecret
        }

        return try await AF.request(
            "https://kauth.kakao.com/oauth/token",
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .httpBody)
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(KakaoTokenResponse.self)
        .value
    }

    private func requestUser(accessToken: String) async throws -> KakaoUserResponse {
        let headers: HTTPHeaders = [
            .authorization(bearerToken: accessToken)
        ]

        return try await AF.request(
            "https://kapi.kakao.com/v2/user/me",
            method: .get,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(KakaoUserResponse.self)
        .value
    }
}
