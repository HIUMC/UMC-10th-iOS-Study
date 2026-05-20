import Foundation

struct SeatModel: Identifiable, Hashable {
    let row: String
    let number: Int

    var id: String {
        "\(row)\(number)"
    }
}
