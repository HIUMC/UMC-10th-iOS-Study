import Foundation

// Identifiable을 채택해야 ForEach에서 id: \.id 없이 깔끔하게 돕니다.
struct MovieModel: Identifiable {
    let id: Int
    let title : String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterImage: String      // 포스터 이미지 이름
    let posterURL: URL?
    let backdropURL: URL?
    let totalAudience: String    // 누적 관객수 (피그마 데이터용)
    let ageRating: String

    init(
        id: Int = Int.random(in: 1...999_999),
        title: String,
        originalTitle: String = "",
        overview: String = "",
        releaseDate: String = "",
        posterImage: String,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        totalAudience: String,
        ageRating: String = "12"
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterImage = posterImage
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.totalAudience = totalAudience
        self.ageRating = ageRating
    }
}
