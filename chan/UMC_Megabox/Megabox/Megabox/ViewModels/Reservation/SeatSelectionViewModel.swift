import Combine
import Foundation

final class SeatSelectionViewModel: ObservableObject {
    @Published var selectedSeats: Set<SeatModel> = []
    @Published private(set) var totalPrice = 0

    let seats: [[SeatModel]]
    let pricePerSeat = 14_000

    private var bag = Set<AnyCancellable>()

    init() {
        seats = ["A", "B", "C", "D", "E"].map { row in
            (1...8).map { SeatModel(row: row, number: $0) }
        }

        $selectedSeats
            .map { [pricePerSeat] seats in
                seats.count * pricePerSeat
            }
            .assign(to: \.totalPrice, on: self)
            .store(in: &bag)
    }

    func toggle(_ seat: SeatModel) {
        if selectedSeats.contains(seat) {
            selectedSeats.remove(seat)
        } else {
            selectedSeats.insert(seat)
        }
    }

    var selectedSeatText: String {
        let sorted = selectedSeats.sorted { first, second in
            if first.row == second.row {
                return first.number < second.number
            }
            return first.row < second.row
        }

        return sorted.isEmpty
            ? "좌석을 선택해주세요"
            : sorted.map(\.id).joined(separator: ", ")
    }
}
