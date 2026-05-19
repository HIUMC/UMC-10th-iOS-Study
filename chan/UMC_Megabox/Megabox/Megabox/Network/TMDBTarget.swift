import Foundation
import Alamofire
import Moya

enum TMDBTarget {
    case nowPlaying(request: NowPlayingRequestDTO)
}

extension TMDBTarget: TargetType {
    nonisolated var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    nonisolated var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        }
    }

    nonisolated var method: Moya.Method {
        switch self {
        case .nowPlaying:
            return .get
        }
    }

    nonisolated var task: Task {
        switch self {
        case .nowPlaying(let request):
            var parameters = request.parameters
            parameters["api_key"] = Bundle.main.tmdbAPIKey

            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }

    nonisolated var sampleData: Data {
        Data()
    }

    nonisolated var headers: [String: String]? {
        [
            "accept": "application/json"
        ]
    }
}
