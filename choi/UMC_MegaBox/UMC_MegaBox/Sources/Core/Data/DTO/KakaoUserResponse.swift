import Foundation

struct KakaoUserResponse: Decodable, Sendable {
    let id: Int64
    let properties: Properties?
    let kakaoAccount: KakaoAccount?

    enum CodingKeys: String, CodingKey {
        case id
        case properties
        case kakaoAccount = "kakao_account"
    }

    var displayName: String {
        kakaoAccount?.name
        ?? kakaoAccount?.profile?.nickname
        ?? properties?.nickname
        ?? "카카오사용자\(id)"
    }

    struct Properties: Decodable, Sendable {
        let nickname: String?
    }

    struct KakaoAccount: Decodable, Sendable {
        let name: String?
        let profile: Profile?
    }

    struct Profile: Decodable, Sendable {
        let nickname: String?
    }
}
