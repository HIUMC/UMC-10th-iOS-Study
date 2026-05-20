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

    var parameters: [String: Any] {
        [
            "language": language,
            "page": page,
            "region": region
        ]
    }
}

struct TMDBNowPlayingResponseDTO: Decodable {
    let dates: TMDBNowPlayingDatesDTO?
    let page: Int
    let results: [TMDBMovieDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TMDBNowPlayingDatesDTO: Decodable {
    let maximum: String
    let minimum: String
}

struct TMDBMovieDTO: Decodable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension TMDBMovieDTO {
    func toMovieModel() -> MovieModel {
        MovieModel(
            id: String(id),
            title: title,
            posterImage: "",
            posterURL: TMDBImageURLBuilder.posterURL(path: posterPath),
            backdropURL: TMDBImageURLBuilder.backdropURL(path: backdropPath),
            audienceCount: 100,
            englishTitle: originalTitle,
            quote: "",
            description: overview.isEmpty ? "영화 소개 정보가 없습니다." : overview,
            ageRating: "12세 이상 관람가",
            releaseInfo: formattedReleaseInfo,
            genre: "-",
            type: "2D",
            director: "-",
            cast: "-"
        )
    }

    private var formattedReleaseInfo: String {
        guard !releaseDate.isEmpty else {
            return "개봉일 정보 없음"
        }
        return "\(releaseDate.replacingOccurrences(of: "-", with: ".")) · 개봉"
    }
}

enum TMDBImageURLBuilder {
    private static let baseURL = "https://image.tmdb.org/t/p"

    static func posterURL(path: String?) -> URL? {
        makeURL(path: path, size: "w500")
    }

    static func backdropURL(path: String?) -> URL? {
        makeURL(path: path, size: "w780")
    }

    private static func makeURL(path: String?, size: String) -> URL? {
        guard let path, !path.isEmpty else {
            return nil
        }
        return URL(string: "\(baseURL)/\(size)\(path)")
    }
}

private enum TMDBConfiguration {
    static var apiKey: String {
        if let infoPlistKey = Bundle.main.object(forInfoDictionaryKey: "TMDBAPIKey") as? String,
           !infoPlistKey.isEmpty,
           !infoPlistKey.contains("$(") {
            return infoPlistKey
        }

        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "xcconfig"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return ""
        }

        return content
            .split(separator: "\n")
            .compactMap { line -> String? in
                let parts = line.split(separator: "=", maxSplits: 1).map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                guard parts.count == 2, parts[0] == "TMDB_API_KEY" else {
                    return nil
                }
                return parts[1]
            }
            .first ?? ""
    }
}

enum TMDBAPI {
    case nowPlaying(TMDBNowPlayingRequestDTO)
}

extension TMDBAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org")!
    }

    var path: String {
        switch self {
        case .nowPlaying:
            return "/3/movie/now_playing"
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
            var parameters = request.parameters
            parameters["api_key"] = TMDBConfiguration.apiKey

            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {
        [
            "accept": "application/json"
        ]
    }

    var sampleData: Data {
        Data()
    }
}

enum TMDBAPIError: LocalizedError {
    case missingAPIKey

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "TMDB API 키가 비어 있습니다. Secrets.xcconfig와 Info.plist 설정을 확인해주세요."
        }
    }
}

extension MoyaProvider {
    func requestAsync(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

struct TMDBMovieService {
    private let provider = MoyaProvider<TMDBAPI>()
    private let decoder = JSONDecoder()

    func fetchNowPlayingMovies(request: TMDBNowPlayingRequestDTO = TMDBNowPlayingRequestDTO()) async throws -> [MovieModel] {
        guard !TMDBConfiguration.apiKey.isEmpty else {
            throw TMDBAPIError.missingAPIKey
        }

        let response = try await provider.requestAsync(.nowPlaying(request))
        let decodedResponse = try decoder.decode(TMDBNowPlayingResponseDTO.self, from: response.data)
        return decodedResponse.results.map { $0.toMovieModel() }
    }
}
