import Foundation

struct NowPlayingRequestDTO {
    let language: String
    let page: Int
    let region: String

    init(language: String = "ko-KR", page: Int = 1, region: String = "KR") {
        self.language = language
        self.page = page
        self.region = region
    }

    nonisolated var parameters: [String: Any] {
        [
            "language": language,
            "page": page,
            "region": region
        ]
    }
}

struct NowPlayingResponseDTO: Decodable {
    let dates: MovieDateDTO?
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

struct MovieDateDTO: Decodable {
    let maximum: String
    let minimum: String
}

struct TMDBMovieDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
