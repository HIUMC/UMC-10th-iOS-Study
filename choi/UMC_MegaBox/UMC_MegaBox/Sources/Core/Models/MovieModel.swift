import Foundation

struct MovieModel: Identifiable, Hashable {
    let id = UUID()

    // MARK: - 홈 화면 (카드)
    let title: String
    let posterImage: String
    let backdropImage: String?
    let audienceCount: Int
    
    // MARK: - 상세 화면
    let englishTitle: String
    let quote: String
    let description: String
    let rating: String
    let releaseInfo: String
    let genre: String
    let type: String
    let director: String
    let cast: String

    init(
        title: String,
        posterImage: String,
        backdropImage: String? = nil,
        audienceCount: Int,
        englishTitle: String,
        quote: String,
        description: String,
        rating: String,
        releaseInfo: String,
        genre: String,
        type: String,
        director: String,
        cast: String
    ) {
        self.title = title
        self.posterImage = posterImage
        self.backdropImage = backdropImage
        self.audienceCount = audienceCount
        self.englishTitle = englishTitle
        self.quote = quote
        self.description = description
        self.rating = rating
        self.releaseInfo = releaseInfo
        self.genre = genre
        self.type = type
        self.director = director
        self.cast = cast
    }

    /// 관객수를 "누적관객수 1000만" 형식으로 포맷팅
    var posterURL: URL? {
        TMDBImageURLBuilder.posterURL(path: posterImage)
    }

    var backdropURL: URL? {
        TMDBImageURLBuilder.backdropURL(path: backdropImage)
    }

    var formattedAudienceCount: String {
        if audienceCount == 0 {
            return "누적관객수 0"
        }
        return "누적관객수 \(audienceCount)만"
    }
}
