import Foundation

struct MenuItemModel: Identifiable, Hashable {
    typealias ID = UUID

    let id: ID
    let name: String
    let description: String?
    let price: Int
    let originalPrice: Int?
    let imageName: String?
    let category: MenuCategory
    let badges: Set<MenuBadge>
    let isSoldOut: Bool

    init(
        id: ID = UUID(),
        name: String,
        description: String? = nil,
        price: Int,
        originalPrice: Int? = nil,
        imageName: String? = nil,
        category: MenuCategory,
        badges: Set<MenuBadge> = [],
        isSoldOut: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.originalPrice = originalPrice
        self.imageName = imageName
        self.category = category
        self.badges = badges
        self.isSoldOut = isSoldOut
    }

    var formattedPrice: String {
        Self.formatWon(price)
    }

    var formattedOriginalPrice: String? {
        originalPrice.map(Self.formatWon)
    }

    var discountRate: Int? {
        badges.compactMap(\.discountRate).max()
    }

    var displayBadges: [MenuBadge] {
        badges.sorted { lhs, rhs in
            if lhs.sortPriority == rhs.sortPriority {
                return lhs.sortValue > rhs.sortValue
            }
            return lhs.sortPriority < rhs.sortPriority
        }
    }

    var isBest: Bool {
        badges.contains(.best)
    }

    var isRecommended: Bool {
        badges.contains(.recommended)
    }

    private static func formatWon(_ value: Int) -> String {
        let sign = value < 0 ? "-" : ""
        let digits = String(abs(value))
        let reversed = Array(digits.reversed())
        let grouped = stride(from: 0, to: reversed.count, by: 3)
            .map { start in
                String(reversed[start..<min(start + 3, reversed.count)].reversed())
            }
            .reversed()
            .joined(separator: ",")
        return "\(sign)\(grouped)원"
    }
}

enum MenuBadge: Hashable {
    case best
    case recommended
    case discount(Int)

    var title: String {
        switch self {
        case .best:
            return "BEST"
        case .recommended:
            return "추천"
        case .discount(let rate):
            return "\(rate)%"
        }
    }

    var discountRate: Int? {
        if case .discount(let rate) = self {
            return rate
        }
        return nil
    }

    var sortPriority: Int {
        switch self {
        case .best:
            return 0
        case .recommended:
            return 1
        case .discount:
            return 2
        }
    }

    var sortValue: Int {
        discountRate ?? 0
    }
}

enum MenuCategory: String, CaseIterable, Hashable, Identifiable {
    case combo
    case package
    case ticket
    case goods

    var id: Self { self }

    var title: String {
        switch self {
        case .combo:
            return "콤보"
        case .package:
            return "패키지"
        case .ticket:
            return "관람권"
        case .goods:
            return "굿즈"
        }
    }

    var symbolName: String {
        switch self {
        case .combo:
            return "popcorn.fill"
        case .package:
            return "takeoutbag.and.cup.and.straw.fill"
        case .ticket:
            return "ticket.fill"
        case .goods:
            return "star.square.fill"
        }
    }
}

enum MobileOrderMenuStore {
    static let loveComboID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let doubleComboID = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
    static let disneyPosterID = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
    static let singlePackageID = UUID(uuidString: "44444444-4444-4444-4444-444444444444")!
    static let loveComboPackageID = UUID(uuidString: "55555555-5555-5555-5555-555555555555")!
    static let singleComboID = UUID(uuidString: "66666666-6666-6666-6666-666666666666")!
    static let familyComboPackageID = UUID(uuidString: "77777777-7777-7777-7777-777777777777")!
    static let ticketID = UUID(uuidString: "88888888-8888-8888-8888-888888888888")!
    static let universalPackageID = UUID(uuidString: "99999999-9999-9999-9999-999999999999")!

    private static let singleCombo = MenuItemModel(
        id: singleComboID,
        name: "싱글 콤보",
        description: "혼자 즐기기 좋은 팝콘과 음료 구성",
        price: 10_900,
        imageName: "mobileOrderSingleCombo",
        category: .combo,
        badges: [.best]
    )

    private static let loveCombo = MenuItemModel(
        id: loveComboID,
        name: "러브 콤보",
        description: "팝콘과 음료를 함께 즐기는 대표 콤보",
        price: 10_900,
        imageName: "mobileOrderLoveCombo",
        category: .combo,
        badges: [.best, .recommended]
    )

    private static let doubleCombo = MenuItemModel(
        id: doubleComboID,
        name: "더블 콤보",
        description: "둘이 함께 즐기기 좋은 더블 구성",
        price: 24_900,
        imageName: "mobileOrderDoubleCombo",
        category: .combo,
        badges: [.best]
    )

    private static let disneyPoster = MenuItemModel(
        id: disneyPosterID,
        name: "디즈니 픽사 포스터",
        description: "디즈니 픽사 한정 포스터",
        price: 15_900,
        imageName: "mobileOrderDisneyPoster",
        category: .goods,
        isSoldOut: true
    )

    private static let singlePackage = MenuItemModel(
        id: singlePackageID,
        name: "싱글 패키지",
        description: "싱글 관람에 맞춘 패키지",
        price: 10_900,
        imageName: "mobileOrderSinglePackageList",
        category: .package,
        badges: [.best]
    )

    private static let loveComboPackage = MenuItemModel(
        id: loveComboPackageID,
        name: "러브 콤보 패키지",
        description: "러브 콤보와 혜택을 함께 담은 패키지",
        price: 32_000,
        imageName: "mobileOrderLoveComboPackage",
        category: .package
    )

    private static let familyComboPackage = MenuItemModel(
        id: familyComboPackageID,
        name: "패밀리 콤보 패키지",
        description: "가족과 함께 나누는 대용량 패키지",
        price: 47_000,
        imageName: "mobileOrderFamilyComboPackage",
        category: .package
    )

    private static let ticket = MenuItemModel(
        id: ticketID,
        name: "일반관람권",
        description: "일반관람권 모바일 교환 상품",
        price: 14_000,
        originalPrice: 15_000,
        imageName: "mobileOrderTicket",
        category: .ticket,
        badges: [.recommended, .discount(7)]
    )

    private static let universalPackage = MenuItemModel(
        id: universalPackageID,
        name: "유니버설픽쳐스 빅5패키지(매니아)",
        description: "유니버설픽쳐스 굿즈 패키지",
        price: 55_000,
        originalPrice: 35_900,
        imageName: "mobileOrderUniversalPackage",
        category: .goods,
        badges: [.discount(35)]
    )

    static let recommendedItems: [MenuItemModel] = [
        loveCombo,
        doubleCombo,
        disneyPoster
    ]

    static let bestItems: [MenuItemModel] = [
        singlePackage,
        doubleCombo,
        loveComboPackage
    ]

    static let directOrderItems: [MenuItemModel] = [
        singleCombo,
        loveCombo,
        doubleCombo,
        loveComboPackage,
        familyComboPackage,
        ticket,
        disneyPoster,
        universalPackage
    ]

    static let items: [MenuItemModel] = {
        var seen = Set<MenuItemModel.ID>()
        return (directOrderItems + recommendedItems + bestItems).filter { item in
            seen.insert(item.id).inserted
        }
    }()

    static var featuredItem: MenuItemModel {
        guard let item = item(id: loveComboID) else {
            preconditionFailure("Featured mobile-order item must exist in MobileOrderMenuStore.items")
        }
        return item
    }

    static func items(in category: MenuCategory) -> [MenuItemModel] {
        items.filter { $0.category == category }
    }

    static func item(id: MenuItemModel.ID) -> MenuItemModel? {
        items.first { $0.id == id }
    }

    static func relatedItems(for item: MenuItemModel, limit: Int = 2) -> [MenuItemModel] {
        Array(items(in: item.category).filter { $0.id != item.id }.prefix(limit))
    }
}
