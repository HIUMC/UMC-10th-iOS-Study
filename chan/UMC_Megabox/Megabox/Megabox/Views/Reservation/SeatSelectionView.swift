import SwiftUI

struct SeatSelectionView: View {
    let movie: ReservationModel
    let theater: Theater
    let auditorium: AuditoriumItemDTO
    let showtime: ShowtimeDTO

    @StateObject private var vm = SeatSelectionViewModel()
    @State private var isPaymentAlertPresented = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 28) {
                    screenSection
                    seatSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 120)
            }

            paymentBar
        }
        .navigationTitle(showtime.start)
        .navigationBarTitleDisplayMode(.inline)
        .alert("결제가 완료되었습니다", isPresented: $isPaymentAlertPresented) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("\(vm.selectedSeatText)\n\(formattedPrice(vm.totalPrice))")
        }
    }

    private var screenSection: some View {
        VStack(spacing: 12) {
            Text("SCREEN")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.75))
                .clipShape(RoundedRectangle(cornerRadius: 4))

            Text("\(theater.rawValue) \(auditorium.auditorium) · \(auditorium.format)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var seatSection: some View {
        VStack(spacing: 10) {
            ForEach(vm.seats, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row) { seat in
                        Button {
                            vm.toggle(seat)
                        } label: {
                            Text("\(seat.number)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .frame(width: 32, height: 32)
                                .background(vm.selectedSeats.contains(seat) ? Color.megaPurple : Color.gray.opacity(0.15))
                                .foregroundStyle(vm.selectedSeats.contains(seat) ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var paymentBar: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(movie.title)
                        .font(.headline)
                    Text("\(theater.rawValue) \(auditorium.auditorium) · \(showtime.toFullTimeString())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(vm.selectedSeatText)
                        .font(.caption)
                        .foregroundStyle(Color.megaPurple)
                }

                Spacer()

                Text(formattedPrice(vm.totalPrice))
                    .font(.headline)
                    .fontWeight(.bold)
            }

            Button {
                isPaymentAlertPresented = true
            } label: {
                Text("결제하기")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(vm.selectedSeats.isEmpty ? Color.gray : Color.megaPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(vm.selectedSeats.isEmpty)
        }
        .padding(20)
        .background(.regularMaterial)
    }

    private func formattedPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "\(formatter.string(from: NSNumber(value: price)) ?? "0")원"
    }
}

#Preview {
    NavigationStack {
        SeatSelectionView(
            movie: .init(posterName: "kingsWarden", title: "왕과 사는 남자", rate: 4.8),
            theater: .gangnam,
            auditorium: .init(
                auditorium: "1관",
                format: "2D",
                showtimes: [.init(start: "11:30", end: "13:40", available: 100, total: 120)]
            ),
            showtime: .init(start: "11:30", end: "13:40", available: 100, total: 120)
        )
    }
}
