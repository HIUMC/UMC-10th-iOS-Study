import Foundation
import Moya

struct TMDBNowPlayingRequestDTO {
    let language: String
    let page: Int
    let region: String

    init(language: String = "ko-KR", page: Int = 1, region: String = "KR") {
        self.language = language
        self.page = page
        self.region = region
    }
}

enum TMDBAPI {
    case nowPlaying(TMDBNowPlayingRequestDTO)
}

extension TMDBAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        }
    }

    var method: Moya.Method {
        switch self {
        case .nowPlaying:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .nowPlaying(let request):
            var parameters: [String: Any] = [
                "language": request.language,
                "page": request.page,
                "region": request.region
            ]

            if let apiKey = Config.tmdbAPIKey {
                parameters["api_key"] = apiKey
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        switch self {
        case .nowPlaying:
            return """
            {
              "page": 1,
              "results": [
                {
                  "adult": false,
                  "backdrop_path": "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg",
                  "genre_ids": [18, 80],
                  "id": 238,
                  "original_language": "en",
                  "original_title": "The Godfather",
                  "overview": "마피아 일가를 둘러싼 권력과 가족의 이야기.",
                  "popularity": 120.5,
                  "poster_path": "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
                  "release_date": "1972-03-14",
                  "title": "대부",
                  "video": false,
                  "vote_average": 8.7,
                  "vote_count": 20000
                }
              ],
              "total_pages": 1,
              "total_results": 1
            }
            """.data(using: .utf8) ?? Data()
        }
    }
}
