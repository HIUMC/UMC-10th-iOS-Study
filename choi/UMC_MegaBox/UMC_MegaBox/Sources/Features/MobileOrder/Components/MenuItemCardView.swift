import SwiftUI

struct MenuItemCardView: View {
    @Environment(\.menuItemCardPresentation) private var presentation

    private let item: MenuItemModel

    init(item: MenuItemModel) {
        self.item = item
    }

    var body: some View {
        VStack(alignment: .leading, spacing: presentation.textTopSpacing) {
            productImage

            VStack(alignment: .leading, spacing: 0) {
                Text(item.name)
                    .font(nameFont)
                    .foregroundStyle(Color(.black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)

                priceView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(item.isSoldOut ? 0.96 : 1)
    }

    private var productImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 247 / 255, green: 247 / 255, blue: 247 / 255))

            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                Image(systemName: item.category.symbolName)
                    .font(.system(size: 54, weight: .semibold))
                    .foregroundStyle(Color(.purple03))
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .conditionalBadges(item: item, isVisible: presentation.showsBadges)
        .soldOutOverlay(item.isSoldOut)
    }

    @ViewBuilder
    private var priceView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            Text(item.formattedPrice)
                .font(.pretend(type: .semibold, size: 14))
                .foregroundStyle(Color(.black))
                .lineLimit(1)

            if let originalPrice = item.formattedOriginalPrice {
                Text(originalPrice)
                    .font(.pretendardRegular9)
                    .foregroundStyle(Color(.gray04))
                    .lineLimit(1)
            }
        }
    }

    private var nameFont: Font {
        switch presentation {
        case .carousel:
            return .pretend(type: .regular, size: 13)
        case .grid:
            return item.name.count > 14 ? .pretendardRegular12 : .pretend(type: .regular, size: 13)
        }
    }
}

private extension MenuItemCardPresentation {
    var showsBadges: Bool {
        self == .grid
    }

    var textTopSpacing: CGFloat {
        switch self {
        case .carousel:
            return 12
        case .grid:
            return 16
        }
    }
}

private extension View {
    @ViewBuilder
    func conditionalBadges(item: MenuItemModel, isVisible: Bool) -> some View {
        if isVisible {
            if item.isBest {
                self.bestBadge(true)
            } else if item.isRecommended {
                self.recommendedBadge(true)
            } else {
                self
            }
        } else {
            self
        }
    }
}

#Preview {
    VStack(spacing: 28) {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MobileOrderMenuStore.recommendedItems) { item in
                    MenuItemCardView(item: item)
                        .frame(width: 158)
                }
            }
            .padding(20)
        }

        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
            ForEach(MobileOrderMenuStore.directOrderItems) { item in
                MenuItemCardView(item: item)
                    .menuItemCardPresentation(.grid)
            }
        }
        .padding(22)
    }
}
