import SwiftUI

struct StatsInfoView: View {
    var body: some View {
        HStack(spacing: 0) {
            StatItemView(title: "쿠폰", value: "3")
            Divider()
                .frame(height: 40)
            StatItemView(title: "스토어 교환권", value: "0")
            Divider()
                .frame(height: 40)
            StatItemView(title: "모바일 티켓", value: "1")
        }
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.gray02))
        )
    }
}

struct StatItemView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 9) {
            Text(title)
                .font(.pretendardSemiBold16)
                .foregroundColor(Color(.gray02))
            Text(value)
                .font(.pretendardSemiBold18)
                .foregroundColor(Color(.black))
        }
        .frame(maxWidth: .infinity)
    }
}
