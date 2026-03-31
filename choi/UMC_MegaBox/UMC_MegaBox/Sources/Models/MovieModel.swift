import Foundation

struct MovieModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let englishTitle: String
    let posterImage: String
    let audienceCount: Int
    let quote: String
    let description: String
    let rating: String
    let releaseInfo: String
    let genre: String
    let type: String
    let director: String
    let cast: String

    /// 관객수를 "누적관객수 1475만" 형식으로 포맷팅
    var formattedAudienceCount: String {
        if audienceCount == 0 {
            return "누적관객수 0"
        }
        return "누적관객수 \(audienceCount)만"
    }
}
