import SwiftUI

enum MenuItemCardPresentation: Hashable {
    case carousel
    case grid
}

private struct MenuItemCardPresentationKey: EnvironmentKey {
    static let defaultValue: MenuItemCardPresentation = .carousel
}

extension EnvironmentValues {
    var menuItemCardPresentation: MenuItemCardPresentation {
        get { self[MenuItemCardPresentationKey.self] }
        set { self[MenuItemCardPresentationKey.self] = newValue }
    }
}

struct MenuItemCardPresentationModifier: ViewModifier {
    let presentation: MenuItemCardPresentation

    func body(content: Content) -> some View {
        content.environment(\.menuItemCardPresentation, presentation)
    }
}

struct LiquidGlassCardModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color.white.opacity(0.58))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.72), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 8)
    }
}

struct LiquidGlassButtonModifier: ViewModifier {
    let cornerRadius: CGFloat
    let fillColor: Color
    let strokeColor: Color
    let shadowColor: Color

    func body(content: Content) -> some View {
        content
            .background(fillColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(strokeColor, lineWidth: 1)
            )
            .shadow(color: shadowColor, radius: 10, x: 0, y: 4)
    }
}

private enum MobileOrderBadgeColor {
    static let best = Color(red: 237 / 255, green: 76 / 255, blue: 87 / 255)
    static let recommended = Color(red: 35 / 255, green: 122 / 255, blue: 202 / 255)
}

struct BestBadgeModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            if isVisible {
                Text("BEST")
                    .font(.pretendardSemiBold12)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 26)
                    .background(MobileOrderBadgeColor.best)
                    .clipShape(Capsule())
                    .padding(7)
            }
        }
    }
}

struct RecommendedBadgeModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            if isVisible {
                Text("추천")
                    .font(.pretendardSemiBold12)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 26)
                    .background(MobileOrderBadgeColor.recommended)
                    .clipShape(Capsule())
                    .padding(7)
            }
        }
    }
}

struct DiscountBadgeModifier: ViewModifier {
    let rate: Int?

    func body(content: Content) -> some View {
        content
    }
}

struct SoldOutOverlayModifier: ViewModifier {
    let isSoldOut: Bool

    func body(content: Content) -> some View {
        content.overlay {
            if isSoldOut {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black.opacity(0.80))
                    .overlay {
                        Text("품절")
                            .font(.pretend(type: .semibold, size: 14))
                            .foregroundStyle(.white)
                    }
            }
        }
    }
}

extension View {
    func menuItemCardPresentation(_ presentation: MenuItemCardPresentation) -> some View {
        modifier(MenuItemCardPresentationModifier(presentation: presentation))
    }

    func liquidGlassCard(cornerRadius: CGFloat = 34) -> some View {
        modifier(LiquidGlassCardModifier(cornerRadius: cornerRadius))
    }

    func liquidGlassButton(
        cornerRadius: CGFloat = 296,
        fillColor: Color,
        strokeColor: Color = .white.opacity(0.72),
        shadowColor: Color = .black.opacity(0.08)
    ) -> some View {
        modifier(
            LiquidGlassButtonModifier(
                cornerRadius: cornerRadius,
                fillColor: fillColor,
                strokeColor: strokeColor,
                shadowColor: shadowColor
            )
        )
    }

    func bestBadge(_ isVisible: Bool) -> some View {
        modifier(BestBadgeModifier(isVisible: isVisible))
    }

    func recommendedBadge(_ isVisible: Bool) -> some View {
        modifier(RecommendedBadgeModifier(isVisible: isVisible))
    }

    func discountBadge(_ rate: Int?) -> some View {
        modifier(DiscountBadgeModifier(rate: rate))
    }

    func soldOutOverlay(_ isSoldOut: Bool) -> some View {
        modifier(SoldOutOverlayModifier(isSoldOut: isSoldOut))
    }
}
