import SwiftUI

struct TheaterChangeBar: View {
    @Environment(\.theaterChangeBarStyle) private var style

    private let branchName: String
    private let onChangeTap: () -> Void

    init(branchName: String, onChangeTap: @escaping () -> Void = {}) {
        self.branchName = branchName
        self.onChangeTap = onChangeTap
    }

    var body: some View {
        HStack(spacing: 10) {
            Image("mobileOrderMapPin")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(style.foregroundColor)
                .frame(width: 27, height: 27)

            Text(branchName)
                .font(.pretendardSemiBold13)
                .foregroundStyle(style.foregroundColor)

            Spacer()

            Button(action: onChangeTap) {
                Text("극장 변경")
                    .font(.pretendardSemiBold13)
                    .foregroundStyle(style.buttonForegroundColor)
                    .frame(width: 67, height: 36)
                    .liquidGlassButton(
                        fillColor: style.buttonBackgroundColor,
                        strokeColor: style.buttonBorderColor,
                        shadowColor: style.buttonShadowColor.opacity(0.28)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(style.backgroundColor)
        .shadow(color: style.shadowColor, radius: 10, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 0) {
        TheaterChangeBar(branchName: "강남")
        TheaterChangeBar(branchName: "강남")
            .theaterChangeBarStyle(.detail)
    }
}
