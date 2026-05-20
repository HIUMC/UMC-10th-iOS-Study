import Combine
import Foundation

final class MobileOrderViewModel: ObservableObject {
    @Published var selectedTheater = "강남"
    @Published var selectedCategory: MenuItemModel.Category = .combo

    let theaters = ["강남", "홍대", "신촌"]

    let items: [MenuItemModel] = [
        .init(
            name: "싱글 콤보",
            description: "팝콘과 탄산음료를 가볍게 즐기는 콤보",
            price: 10_900,
            originalPrice: nil,
            imageName: "mo_single_combo_ticket",
            category: .combo,
            isBest: true,
            isRecommended: true,
            isSoldOut: false
        ),
        .init(
            name: "러브 콤보",
            description: "둘이 먹기 좋은 팝콘과 탄산음료 구성",
            price: 10_900,
            originalPrice: nil,
            imageName: "mo_love_combo",
            category: .combo,
            isBest: true,
            isRecommended: false,
            isSoldOut: false
        ),
        .init(
            name: "더블 콤보",
            description: "팝콘 두 개와 음료 두 잔으로 든든하게",
            price: 13_900,
            originalPrice: nil,
            imageName: "mo_double_combo",
            category: .combo,
            isBest: true,
            isRecommended: false,
            isSoldOut: false
        ),
        .init(
            name: "러브 콤보 패키지",
            description: "러브 콤보와 관람권을 한 번에",
            price: 32_000,
            originalPrice: nil,
            imageName: "mo_single_combo_ticket",
            category: .combo,
            isBest: false,
            isRecommended: false,
            isSoldOut: true
        ),
        .init(
            name: "패밀리 콤보 패키지",
            description: "여럿이 함께 즐기는 풍성한 패키지",
            price: 47_000,
            originalPrice: nil,
            imageName: "mo_family_combo",
            category: .combo,
            isBest: false,
            isRecommended: true,
            isSoldOut: false
        ),
        .init(
            name: "일반관람권",
            description: "2D 일반관에서 사용할 수 있는 관람권",
            price: 14_000,
            originalPrice: 15_000,
            imageName: "mo_general_ticket",
            category: .snack,
            isBest: false,
            isRecommended: true,
            isSoldOut: false
        ),
        .init(
            name: "디즈니 픽사 포스터",
            description: "디즈니 픽사 작품 포스터 컬렉션",
            price: 15_900,
            originalPrice: nil,
            imageName: "mo_disney_poster",
            category: .snack,
            isBest: false,
            isRecommended: false,
            isSoldOut: true
        ),
        .init(
            name: "유니버설픽처스 빅5패키지(매니아)",
            description: "유니버설 인기작 관람 패키지",
            price: 55_000,
            originalPrice: 35_000,
            imageName: "mo_universal_ticket",
            category: .snack,
            isBest: false,
            isRecommended: false,
            isSoldOut: false
        )
    ]

    var filteredItems: [MenuItemModel] {
        items.filter { $0.category == selectedCategory }
    }

    var bestItems: [MenuItemModel] {
        items.filter(\.isBest)
    }

    var recommendedItems: [MenuItemModel] {
        Array(items.prefix(3))
    }
}
