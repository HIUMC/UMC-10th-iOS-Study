import Testing
@testable import UMC_MegaBox

struct MobileOrderModelTests {
    @Test func priceFormattingUsesWonSeparators() {
        let item = MenuItemModel(
            name: "러브 콤보",
            price: 10_900,
            category: .combo
        )

        #expect(item.formattedPrice == "10,900원")
    }

    @Test func discountBadgeValueIsPreservedInModel() {
        let item = MenuItemModel(
            name: "패밀리 콤보",
            price: 18_900,
            originalPrice: 21_000,
            category: .combo,
            badges: [.discount(10), .discount(5)]
        )

        #expect(item.discountRate == 10)
        #expect(item.formattedOriginalPrice == "21,000원")
    }

    @Test func displayBadgesUseStablePresentationOrder() {
        let item = MenuItemModel(
            name: "추천 콤보",
            price: 12_000,
            category: .combo,
            badges: [.discount(10), .recommended, .best]
        )

        #expect(item.displayBadges == [.best, .recommended, .discount(10)])
    }

    @Test func mobileOrderRouteUsesMenuItemIdentifierOnly() {
        let item = MobileOrderMenuStore.featuredItem
        let route = MobileOrderRoute.detail(item.id)

        switch route {
        case .detail(let id):
            #expect(id == item.id)
        }
    }

    @Test func featuredItemUsesStableStoreIdentifier() {
        #expect(MobileOrderMenuStore.featuredItem.id == MobileOrderMenuStore.loveComboID)
    }
}
