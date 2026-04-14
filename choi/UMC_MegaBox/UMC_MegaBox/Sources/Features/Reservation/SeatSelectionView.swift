import SwiftUI

struct SeatSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SeatSelectionViewModel

    init(params: SeatSelectionParams) {
        self._viewModel = State(
            initialValue: SeatSelectionViewModel(
                movie: params.movie,
                theaterBranch: params.theaterBranch,
                showtime: params.showtime,
                selectedDate: params.selectedDate
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            // 좌석 배치 영역
            seatArea

            Spacer()

            // 하단 결제 바
            paymentBar
        }
        .background(Color(.gray09))
        .navigationTitle(viewModel.navigationTitleText)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(.gray07))
                }
            }
        }
        .alert("결제 확인", isPresented: $viewModel.showPaymentAlert) {
            Button("확인", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("\(viewModel.movie.title)\n\(viewModel.theaterBranch) \(viewModel.showtime.screenName)\n성인\(viewModel.selectedCount) / \(viewModel.formattedPrice)\n결제가 완료되었습니다.")
        }
    }

    // MARK: - SCREEN + 좌석 그리드

    private var seatArea: some View {
        VStack(spacing: 20) {
            // SCREEN 라벨
            Text("SCREEN")
                .font(.pretendardBold24)
                .foregroundStyle(Color(.gray03))
                .frame(maxWidth: .infinity)
                .padding(.top, 26)
                .padding(.bottom, 80)

            // 좌석 그리드
            VStack(spacing: 6) {
                ForEach(viewModel.seats.indices, id: \.self) { rowIndex in
                    HStack(spacing: 6) {
                        ForEach(viewModel.seats[rowIndex].indices, id: \.self) { colIndex in
                            let seat = viewModel.seats[rowIndex][colIndex]
                            seatCell(seat, rowIndex: rowIndex, colIndex: colIndex)
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
        }
    }

    private func seatCell(_ seat: SeatModel, rowIndex: Int, colIndex: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.toggleSeat(row: rowIndex, col: colIndex)
            }
        } label: {
            Text(seat.seatLabel)
                .font(.pretendardSemiBold12)
                .foregroundStyle(.white)
                .frame(width: 35, height: 35)
                .background(seat.isSelected ? Color(.purple03) : Color(.saturday))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            seat.isSelected ? Color(.purple05) : Color(.saturday).opacity(0.7),
                            lineWidth: 1
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 2)
                )

        }
    }

    // MARK: - 하단 결제 바

    private var paymentBar: some View {
        VStack(spacing: 0) {
            // 영화 정보
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.movie.title)
                    .font(.pretendardBold18)
                    .foregroundStyle(Color(.gray07))

                Text("\(viewModel.theaterBranch) \(viewModel.showtime.screenName)")
                    .font(.pretendardRegular13)
                    .foregroundStyle(Color(.gray04))

                HStack {
                    if viewModel.selectedCount > 0 {
                        Text("성인\(viewModel.selectedCount)")
                            .font(.pretendardMedium14)
                            .foregroundStyle(Color(.gray07))
                    }
                    Spacer()
                    Text(viewModel.formattedPrice)
                        .font(.pretendardBold18)
                        .foregroundStyle(Color(.gray07))
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            // 결제 버튼
            Button {
                if viewModel.selectedCount > 0 {
                    viewModel.showPaymentAlert = true
                }
            } label: {
                Text("결제하기")
                    .font(.pretendardBold18)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        viewModel.selectedCount > 0
                            ? Color(.purple03)
                            : Color(.gray03)
                    )
                    .cornerRadius(10)
            }
            .disabled(viewModel.selectedCount == 0)
            .padding(.horizontal, 20)
            .padding(.top, 30)
        }
        .background(
                Color(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(edges: .bottom)
            )
    }
}

#Preview {
    NavigationStack {
        SeatSelectionView(
            params: SeatSelectionParams(
                movie: MovieModel(
                    title: "왕과 사는 남자",
                    posterImage: "kingsWarden",
                    audienceCount: 1000,
                    englishTitle: "",
                    quote: "",
                    description: "",
                    rating: "12세 이상 관람가",
                    releaseInfo: "",
                    genre: "",
                    type: "",
                    director: "",
                    cast: ""
                ),
                theaterBranch: "강남",
                showtime: ShowtimeModel(
                    theaterBranch: "강남",
                    screenName: "르 리클라이너 1관",
                    format: "2D",
                    time: "11:30",
                    endTime: "~13:58",
                    totalSeats: 116,
                    remainingSeats: 109
                ),
                selectedDate: CalendarDay.generateWeek().first!
            )
        )
    }
}
