import Foundation
import Combine

@Observable
class SeatSelectionViewModel {

    // MARK: - 좌석 데이터

    var seats: [[SeatModel]] = []   // 6행 x 7열
    var selectedCount: Int = 0
    var totalPrice: Int = 0

    let pricePerSeat: Int = 14_000

    // MARK: - 영화/상영 정보

    let movie: MovieModel
    let theaterBranch: String
    let showtime: ShowtimeModel

    // MARK: - Alert 상태

    var showPaymentAlert: Bool = false

    // MARK: - Combine

    private let selectedSeatsSubject = CurrentValueSubject<Int, Never>(0)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(movie: MovieModel, theaterBranch: String, showtime: ShowtimeModel) {
        self.movie = movie
        self.theaterBranch = theaterBranch
        self.showtime = showtime
        generateSeats()
        setupPricePipeline()
    }

    // MARK: - 6x7 좌석 그리드 생성

    private func generateSeats() {
        let rows: [Character] = ["A", "B", "C", "D", "E", "F"]
        seats = rows.map { row in
            (1...7).map { col in
                SeatModel(row: row, column: col)
            }
        }
    }

    // MARK: - Combine 가격 파이프라인

    private func setupPricePipeline() {
        selectedSeatsSubject
            .map { [weak self] count -> Int in
                guard let self else { return 0 }
                return count * self.pricePerSeat
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                self?.totalPrice = price
            }
            .store(in: &cancellables)
    }

    // MARK: - 좌석 토글

    func toggleSeat(row: Int, col: Int) {
        seats[row][col].isSelected.toggle()
        selectedCount = seats.flatMap { $0 }.filter { $0.isSelected }.count
        selectedSeatsSubject.send(selectedCount)
    }

    // MARK: - 포맷된 가격

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: totalPrice)) ?? "0") + "원"
    }
}
