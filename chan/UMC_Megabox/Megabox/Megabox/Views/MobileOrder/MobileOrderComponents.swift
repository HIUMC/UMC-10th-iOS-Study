import SwiftUI

struct TheaterChangeBar: View {
    let selectedTheater: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 16, weight: .semibold))

                Text("메가박스 \(selectedTheater)")
                    .font(.system(size: 15, weight: .bold))

                Spacer()

                Text("극장변경")
                    .font(.system(size: 13, weight: .semibold))

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
        .buttonStyle(.plain)
    }
}

struct TheaterBarStyleModifier: ViewModifier {
    let foreground: Color
    let background: Color
    let border: Color

    func body(content: Content) -> some View {
        content
            .foregroundStyle(foreground)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func theaterBarStyle(foreground: Color, background: Color, border: Color = .clear) -> some View {
        modifier(TheaterBarStyleModifier(foreground: foreground, background: background, border: border))
    }
}

struct MenuItemCard: View {
    let item: MenuItemModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(height: 132)

                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: 132)

                HStack(spacing: 6) {
                    Text("BEST")
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(Color.megaPurple)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .bestBadge(item.isBest)

                    Text("추천")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .recommendBadge(item.isRecommended)
                }
                .padding(8)
            }
            .soldOut(item.isSoldOut)

            Text(item.name)
                .font(.system(size: 15, weight: .bold))
                .lineLimit(1)

            Text(item.description)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(minHeight: 34, alignment: .topLeading)

            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text("\(item.price.formatted())원")
                    .font(.system(size: 15, weight: .black))

                if let originalPrice = item.originalPrice {
                    Text("\(originalPrice.formatted())원")
                        .font(.system(size: 11))
                        .strikethrough()
                        .foregroundStyle(.secondary)
                }
            }
            .discount(item.discountRate)
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .menuShadow(!item.isSoldOut)
    }
}

struct BestBadgeModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content.opacity(isVisible ? 1 : 0)
    }
}

struct RecommendBadgeModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content.opacity(isVisible ? 1 : 0)
    }
}

struct SoldOutModifier: ViewModifier {
    let isSoldOut: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isSoldOut {
                    ZStack {
                        Color.black.opacity(0.56)
                        Text("품절")
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(.white)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .opacity(isSoldOut ? 0.72 : 1)
    }
}

struct DiscountModifier: ViewModifier {
    let rate: Int?

    func body(content: Content) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            if let rate {
                Text("\(rate)%")
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(.red)
            }
            content
        }
    }
}

struct MenuShadowModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content.shadow(color: .black.opacity(isVisible ? 0.1 : 0), radius: 10, x: 0, y: 4)
    }
}

extension View {
    func bestBadge(_ isVisible: Bool) -> some View {
        modifier(BestBadgeModifier(isVisible: isVisible))
    }

    func recommendBadge(_ isVisible: Bool) -> some View {
        modifier(RecommendBadgeModifier(isVisible: isVisible))
    }

    func soldOut(_ isSoldOut: Bool) -> some View {
        modifier(SoldOutModifier(isSoldOut: isSoldOut))
    }

    func discount(_ rate: Int?) -> some View {
        modifier(DiscountModifier(rate: rate))
    }

    func menuShadow(_ isVisible: Bool) -> some View {
        modifier(MenuShadowModifier(isVisible: isVisible))
    }
}
