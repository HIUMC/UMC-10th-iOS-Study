import Foundation

struct MenuItemModel: Identifiable, Hashable {
    enum Category: String, CaseIterable {
        case combo = "콤보"
        case popcorn = "팝콘"
        case drink = "음료"
        case snack = "스낵"
    }

    let id: UUID = .init()
    let name: String
    let description: String
    let price: Int
    let originalPrice: Int?
    let imageName: String
    let category: Category
    let isBest: Bool
    let isRecommended: Bool
    let isSoldOut: Bool

    var discountRate: Int? {
        guard let originalPrice, originalPrice > price else { return nil }
        return Int(((Double(originalPrice - price) / Double(originalPrice)) * 100).rounded())
    }
}
