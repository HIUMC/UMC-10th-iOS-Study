import SwiftUI

struct MenuItemModel: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Int
    let originalPrice: Int?
    let imageName: String?
    let fallbackSymbol: String
    let isBest: Bool
    let isRecommended: Bool
    let isSoldOut: Bool
    let discountRate: Int?

    var formattedPrice: String {
        price.formatted(.number) + "원"
    }

    var formattedOriginalPrice: String? {
        originalPrice.map { $0.formatted(.number) + "원" }
    }
}

extension MenuItemModel {
    static let quickOrder = MenuItemModel(
        id: "quick-order",
        name: "바로 주문",
        price: 0,
        originalPrice: nil,
        imageName: nil,
        fallbackSymbol: "popcorn.fill",
        isBest: false,
        isRecommended: false,
        isSoldOut: false,
        discountRate: nil
    )

    static let recommended: [MenuItemModel] = [
        MenuItemModel(id: "love-combo", name: "러브 콤보", price: 10_900, originalPrice: nil, imageName: "loveCombo", fallbackSymbol: "popcorn.fill", isBest: false, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "double-combo", name: "더블 콤보", price: 24_900, originalPrice: nil, imageName: "doubleCombo", fallbackSymbol: "popcorn.fill", isBest: false, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "disney-poster", name: "디즈니 픽사 포스터", price: 15_900, originalPrice: nil, imageName: "poster", fallbackSymbol: "photo.stack.fill", isBest: false, isRecommended: true, isSoldOut: false, discountRate: nil)
    ]

    static let best: [MenuItemModel] = [
        MenuItemModel(id: "single-package", name: "싱글 패키지", price: 10_900, originalPrice: nil, imageName: "singlePkg", fallbackSymbol: "popcorn.fill", isBest: true, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "best-double", name: "더블 콤보", price: 24_900, originalPrice: nil, imageName: "doubleCombo", fallbackSymbol: "popcorn.fill", isBest: true, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "love-package", name: "러브 콤보 패키지", price: 32_000, originalPrice: nil, imageName: "loveComboPkg", fallbackSymbol: "popcorn.fill", isBest: false, isRecommended: false, isSoldOut: false, discountRate: nil)
    ]

    static let orderMenu: [MenuItemModel] = [
        MenuItemModel(id: "detail-single", name: "싱글 콤보", price: 10_900, originalPrice: nil, imageName: "singlePkg", fallbackSymbol: "popcorn.fill", isBest: true, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "detail-love", name: "러브 콤보", price: 10_900, originalPrice: nil, imageName: "loveCombo", fallbackSymbol: "popcorn.fill", isBest: true, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "detail-double", name: "더블 콤보", price: 13_900, originalPrice: nil, imageName: "doubleCombo", fallbackSymbol: "popcorn.fill", isBest: true, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "detail-love-package", name: "러브 콤보 패키지", price: 32_000, originalPrice: nil, imageName: "loveComboPkg", fallbackSymbol: "popcorn.fill", isBest: false, isRecommended: false, isSoldOut: true, discountRate: nil),
        MenuItemModel(id: "detail-memory", name: "패밀리 콤보 패키지", price: 47_000, originalPrice: nil, imageName: "familyComboPkg", fallbackSymbol: "popcorn.fill", isBest: false, isRecommended: false, isSoldOut: false, discountRate: nil),
        MenuItemModel(id: "detail-coupon", name: "일반 관람권", price: 14_000, originalPrice: 16_000, imageName: "bigFivePkg", fallbackSymbol: "ticket.fill", isBest: false, isRecommended: true, isSoldOut: false, discountRate: 12),
        MenuItemModel(id: "detail-poster", name: "디즈니 픽사 포스터", price: 15_900, originalPrice: nil, imageName: "poster", fallbackSymbol: "photo.stack.fill", isBest: false, isRecommended: false, isSoldOut: true, discountRate: nil),
        MenuItemModel(id: "detail-universal", name: "유니버셜 픽처스 빅5티켓", price: 55_000, originalPrice: 58_000, imageName: "ticket", fallbackSymbol: "ticket.fill", isBest: false, isRecommended: false, isSoldOut: false, discountRate: 5)
    ]
}

struct MobileOrderView: View {
    @Environment(NavigationRouter<MobileOrderRoute>.self) private var router

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.path) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    logoHeader
                    TheaterSelectionBar(theaterName: "강남", theme: .brand, onChangeTheater: {})
                    serviceCards
                        .padding(.top, 18)
                        .padding(.horizontal, 20)
                    MenuSection(title: "추천 메뉴", subtitle: "영화 볼 때 뭐 먹을지 고민될 땐 추천 메뉴!", items: MenuItemModel.recommended)
                        .padding(.top, 34)
                    MenuSection(title: "베스트 메뉴", subtitle: "영화 볼 때 뭐 먹을지 고민될 땐 베스트 메뉴!", items: MenuItemModel.best)
                        .padding(.top, 28)
                        .padding(.bottom, 32)
                }
            }
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: MobileOrderRoute.self) { route in
                switch route {
                case .menuDetail(let item):
                    MobileOrderDetailView(item: item)
                }
            }
        }
    }

    private var logoHeader: some View {
        HStack {
            Image("meboxLogo1")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 26)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 22)
        .padding(.bottom, 14)
    }

    private var serviceCards: some View {
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                GeometryReader { geometry in
                    let rightCardWidth = geometry.size.width * 0.37

                    HStack(alignment: .top, spacing: 12) {
                        Button {
                            router.push(.menuDetail(.quickOrder))
                        } label: {
                            MobileOrderActionCard(
                                title: "바로 주문",
                                subtitle: "이제 줄서지 말고\n모바일로 주문하고 픽업!",
                                symbol: "popcorn",
                                height: 248
                            )
                        }
                        .buttonStyle(.plain)

                        VStack(spacing: 12) {
                            MobileOrderActionCard(title: "스토어 교환권", subtitle: nil, symbol: "ticket", height: 118)
                            MobileOrderActionCard(title: "선물하기", subtitle: nil, symbol: "gift", height: 118)
                        }
                        .frame(width: rightCardWidth)
                    }
                }
                .frame(height: 248)

                MobileOrderActionCard(
                    title: "어디서든 팝콘 만나기",
                    subtitle: "팝콘 콜라 스낵 모든 메뉴 배달 가능!",
                    symbol: "scooter",
                    height: 86
                )
            }
        }
    }
}

struct TheaterSelectionBar: View {
    enum Theme {
        case brand
        case detail
    }

    let theaterName: String
    let theme: Theme
    let onChangeTheater: () -> Void

    private var locationIconName: String {
        switch theme {
        case .brand:
            return "map_fill"
        case .detail:
            return "map_fill_Dark"
        }
    }

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(locationIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(theaterName)
            }
                .pretendStyle(.semiBold13)
            Spacer()
            Button("극장 변경", action: onChangeTheater)
                .pretendStyle(.medium10)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .buttonStyle(.glass(.regular.tint(.white.opacity(0.14)).interactive()))
        }
        .padding(.horizontal, 20)
        .frame(height: 48)
        .theaterBarStyle(theme)
    }
}

struct MobileOrderActionCard: View {
    let title: String
    let subtitle: String?
    let symbol: String
    let height: CGFloat

    var body: some View {
        Group {
            if height <= 100 {
                HStack {
                    cardText
                    Spacer(minLength: 8)
                    cardIcon
                }
            } else {
                VStack(alignment: .leading) {
                    cardText
                    Spacer(minLength: 8)
                    HStack {
                        Spacer()
                        cardIcon
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))
    }

    private var cardText: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .pretendStyle(.bold18)
                .foregroundStyle(.black)

            if let subtitle {
                Text(subtitle)
                    .pretendStyle(.regular12)
                    .foregroundStyle(Color(.gray03))
                    .multilineTextAlignment(.leading)
            }
        }
    }

    private var cardIcon: some View {
        Image(systemName: symbol)
            .font(.system(size: 28, weight: .medium))
            .foregroundStyle(.black)
    }
}

struct MenuSection: View {
    let title: String
    let subtitle: String
    let items: [MenuItemModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .pretendStyle(.bold18)
                    .foregroundStyle(.black)
                Text(subtitle)
                    .pretendStyle(.regular12)
                    .foregroundStyle(Color(.gray03))
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(items) { item in
                        MenuItemCard(item: item)
                            .frame(width: 124)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct MenuItemCard: View {
    let item: MenuItemModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.gray02).opacity(0.5))

                Group {
                    if let imageName = item.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(6)
                    } else {
                        Image(systemName: item.fallbackSymbol)
                            .font(.system(size: 38))
                            .foregroundStyle(Color(.purple03))
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .soldOut(item.isSoldOut)
                .bestBadge(item.isBest)
                .recommendBadge(item.isRecommended)
            }

            Text(item.name)
                .pretendStyle(.semiBold12)
                .foregroundStyle(Color(.gray07))
                .lineLimit(1)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(item.formattedPrice)
                    .pretendStyle(.semiBold12)
                    .foregroundStyle(.black)
                if let originalPrice = item.formattedOriginalPrice {
                    Text(originalPrice)
                        .pretendStyle(.regular09)
                        .foregroundStyle(Color(.gray03))
                        .strikethrough()
                }
            }
            .discount(item.discountRate)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MobileOrderDetailView: View {
    let item: MenuItemModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            detailNavigationBar
            TheaterSelectionBar(theaterName: "강남", theme: .detail, onChangeTheater: {})

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                    ForEach(MenuItemModel.orderMenu) { menuItem in
                        MenuItemCard(item: menuItem)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 28)
            }
        }
        .background(Color.white)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var detailNavigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.black)
                    .glassEffect(.regular.interactive(), in: .circle)
            }

            Spacer()
            Text("바로주문")
                .pretendStyle(.semiBold16)
                .foregroundStyle(.black)
            Spacer()

            Button {} label: {
                Image(systemName: "cart")
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.black)
                    .glassEffect(.regular.interactive(), in: .circle)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

private struct TheaterBarStyleModifier: ViewModifier {
    let theme: TheaterSelectionBar.Theme

    func body(content: Content) -> some View {
        switch theme {
        case .brand:
            content
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        colors: [Color(.purple03), Color(.purple03).opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        case .detail:
            content
                .foregroundStyle(.black)
                .background(.white)
                .overlay(alignment: .bottom) {
                    Divider()
                        .foregroundStyle(Color(.gray02))
                }
        }
    }
}

private struct BestBadgeModifier: ViewModifier {
    let isBest: Bool

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            if isBest {
                Text("BEST")
                    .pretendStyle(.medium10)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.78), in: Capsule())
                    .padding(7)
            }
        }
    }
}

private struct RecommendBadgeModifier: ViewModifier {
    let isRecommended: Bool

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            if isRecommended {
                Text("추천")
                    .pretendStyle(.medium10)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue, in: Capsule())
                    .padding(7)
            }
        }
    }
}

private struct SoldOutModifier: ViewModifier {
    let isSoldOut: Bool

    func body(content: Content) -> some View {
        content.overlay {
            if isSoldOut {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.65))
            }
        }
    }
}

private struct DiscountModifier: ViewModifier {
    let discountRate: Int?

    func body(content: Content) -> some View {
        HStack(spacing: 4) {
            content
            if let discountRate {
                Text("\(discountRate)%")
                    .pretendStyle(.medium08)
                    .foregroundStyle(Color(.purple03))
            }
        }
    }
}

private extension View {
    func theaterBarStyle(_ theme: TheaterSelectionBar.Theme) -> some View {
        modifier(TheaterBarStyleModifier(theme: theme))
    }

    func bestBadge(_ isBest: Bool) -> some View {
        modifier(BestBadgeModifier(isBest: isBest))
    }

    func recommendBadge(_ isRecommended: Bool) -> some View {
        modifier(RecommendBadgeModifier(isRecommended: isRecommended))
    }

    func soldOut(_ isSoldOut: Bool) -> some View {
        modifier(SoldOutModifier(isSoldOut: isSoldOut))
    }

    func discount(_ discountRate: Int?) -> some View {
        modifier(DiscountModifier(discountRate: discountRate))
    }
}

#Preview {
    MobileOrderView()
        .environment(NavigationRouter<MobileOrderRoute>())
}

#Preview("Detail") {
    MobileOrderDetailView(item: .quickOrder)
}
