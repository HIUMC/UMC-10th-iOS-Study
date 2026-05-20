import Foundation

struct TMDBNowPlayingResponseDTO: Decodable {
    let page: Int
    let results: [TMDBMovieDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
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
    func toMovieModel(audienceCount: Int = 100) -> MovieModel {
        MovieModel(
            title: title,
            posterImage: posterPath ?? "",
            backdropImage: backdropPath,
            audienceCount: audienceCount,
            englishTitle: originalTitle,
            quote: "현재 상영 중인 영화입니다.",
            description: overview.isEmpty ? "줄거리 정보가 없습니다." : overview,
            rating: "12세 이상 관람가",
            releaseInfo: formattedReleaseInfo,
            genre: genreNames,
            type: "2D",
            director: "정보 없음",
            cast: "정보 없음"
        )
    }

    private var formattedReleaseInfo: String {
        guard !releaseDate.isEmpty else { return "개봉일 정보 없음" }
        return "\(releaseDate.replacingOccurrences(of: "-", with: ".")) · 개봉"
    }

    private var genreNames: String {
        let names = genreIDs.compactMap { TMDBGenre.name(for: $0) }
        return names.isEmpty ? "정보 없음" : names.joined(separator: ", ")
    }
}

enum TMDBGenre {
    private static let namesByID: [Int: String] = [
        12: "모험",
        14: "판타지",
        16: "애니메이션",
        18: "드라마",
        27: "공포",
        28: "액션",
        35: "코미디",
        36: "역사",
        37: "서부",
        53: "스릴러",
        80: "범죄",
        99: "다큐멘터리",
        878: "SF",
        9648: "미스터리",
        10402: "음악",
        10749: "로맨스",
        10751: "가족",
        10752: "전쟁",
        10770: "TV 영화"
    ]

    static func name(for id: Int) -> String? {
        namesByID[id]
    }
}
