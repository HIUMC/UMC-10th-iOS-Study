import Foundation

struct ShowtimeModel: Identifiable, Hashable {
    let id = UUID()
    let theaterBranch: String   // "강남", "홍대"
    let screenName: String      // "르 리클라이너 1관"
    let format: String          // "2D"
    let time: String            // "11:30"
    let endTime: String         // "~13:58"
    let totalSeats: Int         // 116
    let remainingSeats: Int     // 109
}
