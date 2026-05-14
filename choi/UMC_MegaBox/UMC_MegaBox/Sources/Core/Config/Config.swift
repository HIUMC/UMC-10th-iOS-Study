import Foundation

enum Config {
    private static let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]

    static var kakaoRestAPIKey: String {
        value(for: "KAKAO_REST_API_KEY")
    }

    static var kakaoClientSecret: String? {
        optionalValue(for: "KAKAO_CLIENT_SECRET")
    }

    static var kakaoRedirectURI: String {
        value(for: "KAKAO_REDIRECT_URI")
    }

    static var tmdbAPIKey: String? {
        optionalValue(for: "TMDB_API_KEY")
    }


    private static func value(for key: String) -> String {
        guard let value = optionalValue(for: key) else {
            fatalError("\(key) 값이 Info.plist/Secret.xcconfig에 없습니다.")
        }
        return value
    }

    private static func optionalValue(for key: String) -> String? {
        guard let value = infoDictionary[key] as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !trimmed.contains("REPLACE_ME"), !trimmed.contains("$(") else {
            return nil
        }
        return trimmed
    }
}
