import Foundation

struct SeatModel: Identifiable, Hashable {
    let id = UUID()
    let row: Character    // A ~ F
    let column: Int       // 1 ~ 7
    var isSelected: Bool = false

    var seatLabel: String {
        "\(row)\(column)"
    }
}
