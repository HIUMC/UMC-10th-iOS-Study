import SwiftUI

/// 상영시간 카드 (시작시간 + 종료시간 + 잔여/전체 좌석)
struct ShowtimeCardView: View {
    let showtime: ShowtimeModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(showtime.time)
                    .font(.pretendardBold18)
                    .foregroundStyle(Color(.gray07))

                Text(showtime.endTime)
                    .font(.pretendardRegular12)
                    .foregroundStyle(Color(.gray03))

                HStack(spacing: 2) {
                    Text("\(showtime.remainingSeats)")
                        .font(.pretendardSemiBold12)
                        .foregroundStyle(seatCountColor)
                    Text("/ \(showtime.totalSeats)")
                        .font(.pretendardRegular12)
                        .foregroundStyle(Color(.gray03))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color(.white))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.gray01), lineWidth: 1)
            )
        }
    }

    /// 잔여 좌석 비율에 따른 색상 (빨강 ≤10%, 주황 ≤30%, 보라 >30%)
    private var seatCountColor: Color {
        let ratio = Double(showtime.remainingSeats) / Double(showtime.totalSeats)
        if ratio <= 0.1 { return .red }
        if ratio <= 0.3 { return .orange }
        return Color(.purple03)
    }
}
