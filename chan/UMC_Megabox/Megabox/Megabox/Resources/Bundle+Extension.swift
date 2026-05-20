import Foundation

extension Bundle {

    nonisolated var kakaoNativeAppKey: String {
        guard let key = infoDictionary?["KakaoNativeAppKey"] as? String,
              key.isEmpty == false,
              key != "$(KAKAO_NATIVE_APP_KEY)" else {
            fatalError("KakaoNativeAppKey missing in Info.plist")
        }
        return key
    }

    var kakaoRestKey: String {
        guard let key = infoDictionary?["KakaoRESTKey"] as? String else {
            fatalError("KakaoRESTKey missing in Info.plist")
        }
        return key
    }

    var kakaoSecret: String {
        guard let key = infoDictionary?["KakaoClientSecret"] as? String else {
            fatalError("KakaoClientSecret missing in Info.plist")
        }
        return key
    }

    nonisolated var tmdbAPIKey: String {
        infoDictionary?["TMDBAPIKey"] as? String ?? "YOUR_TMDB_API_KEY"
    }

    nonisolated var hasValidTMDBAPIKey: Bool {
        tmdbAPIKey.isEmpty == false
        && tmdbAPIKey != "YOUR_TMDB_API_KEY"
        && tmdbAPIKey != "$(TMDB_API_KEY)"
    }
}
