import SwiftUI

struct OrderShortcutCardView: View {
    private let action: () -> Void

    private enum ShortcutIcon {
        case system(String)
        case asset(String)
    }

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let gap: CGFloat = 18
            let sideGap: CGFloat = 10
            let bigWidth = min(232, max(204, width * 0.58))
            let sideWidth = width - bigWidth - gap
            let bigHeight = bigWidth * 310 / 232
            let sideHeight = (bigHeight - sideGap) / 2

            VStack(spacing: 18) {
                HStack(alignment: .top, spacing: gap) {
                    Button(action: action) {
                        shortcutCard(
                            title: "바로 주문",
                            subtitle: "이제 줄서지 말고\n모바일로 주문하고 픽업!",
                            icon: .system("popcorn"),
                            titleFont: .pretendardBold24,
                            subtitleFont: .pretendardRegular12,
                            iconSize: 50,
                            horizontalPadding: 16,
                            verticalPadding: 21,
                            iconAlignment: .bottomTrailing
                        )
                    }
                    .buttonStyle(.plain)
                    .frame(width: bigWidth, height: bigHeight)

                    VStack(spacing: sideGap) {
                        shortcutCard(
                            title: "스토어 교환권",
                            subtitle: nil,
                            icon: .system("ticket"),
                            titleFont: .pretendardBold22,
                            subtitleFont: .pretendardRegular12,
                            iconSize: 50,
                            horizontalPadding: 16,
                            verticalPadding: 21,
                            iconAlignment: .bottomTrailing
                        )
                        .frame(width: sideWidth, height: sideHeight)

                        shortcutCard(
                            title: "선물하기",
                            subtitle: nil,
                            icon: .system("gift"),
                            titleFont: .pretendardBold22,
                            subtitleFont: .pretendardRegular12,
                            iconSize: 50,
                            horizontalPadding: 16,
                            verticalPadding: 21,
                            iconAlignment: .bottomTrailing
                        )
                        .frame(width: sideWidth, height: sideHeight)
                    }
                }

                shortcutCard(
                    title: "어디서든 팝콘 만나기",
                    subtitle: "팝콘 콜라 스낵 모든 메뉴 배달 가능!",
                    icon: .asset("mobileOrderDeliveryCar"),
                    titleFont: .pretendardBold22,
                    subtitleFont: .pretendardRegular12,
                    iconSize: 50,
                    horizontalPadding: 16,
                    verticalPadding: 25,
                    iconAlignment: .trailing
                )
                .frame(width: width, height: 104)
            }
        }
        .frame(height: 432)
        .accessibilityElement(children: .contain)
    }

    private func shortcutCard(
        title: String,
        subtitle: String?,
        icon: ShortcutIcon,
        titleFont: Font,
        subtitleFont: Font,
        iconSize: CGFloat,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        iconAlignment: Alignment
    ) -> some View {
        ZStack(alignment: iconAlignment) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(Color(.black))
                    .lineLimit(2)
                    .minimumScaleFactor(0.68)

                if let subtitle {
                    Text(subtitle)
                        .font(subtitleFont)
                        .foregroundStyle(Color(.gray04))
                        .lineSpacing(1)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            shortcutIcon(icon, size: iconSize)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .liquidGlassCard(cornerRadius: 34)
    }

    @ViewBuilder
    private func shortcutIcon(_ icon: ShortcutIcon, size: CGFloat) -> some View {
        switch icon {
        case .system(let symbolName):
            Image(systemName: symbolName)
                .font(.system(size: size, weight: .regular))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(Color(.black))
        case .asset(let assetName):
            Image(assetName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color(.black))
                .frame(width: size, height: size)
        }
    }
}

#Preview {
    OrderShortcutCardView(action: {})
        .padding(20)
        .frame(width: 440)
}
