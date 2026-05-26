import SwiftUI

struct MobileOrderView: View {
    @Environment(NavigationRouter<MobileOrderRoute>.self) private var router
    @State private var selectedBranch = "강남"
    @State private var isTheaterNoticePresented = false

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.path) {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        logoHeader

                        TheaterChangeBar(branchName: selectedBranch) {
                            isTheaterNoticePresented = true
                        }

                        OrderShortcutCardView {
                            router.push(.detail(MobileOrderMenuStore.featuredItem.id))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        MenuCarouselSection(
                            title: "추천 메뉴",
                            subtitle: "영화 볼때 뭐먹지 고민될 땐 추천 메뉴!",
                            items: MobileOrderMenuStore.recommendedItems
                        ) { item in
                            router.push(.detail(item.id))
                        }
                        .padding(.top, 12)

                        MenuCarouselSection(
                            title: "베스트 메뉴",
                            subtitle: "영화 볼때 뭐먹지 고민될 때 베스트 메뉴!",
                            items: MobileOrderMenuStore.bestItems
                        ) { item in
                            router.push(.detail(item.id))
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 120)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: MobileOrderRoute.self) { route in
                switch route {
                case .detail(let itemID):
                    if let item = MobileOrderMenuStore.item(id: itemID) {
                        MobileOrderDetailView(item: item, branchName: selectedBranch)
                    } else {
                        MissingMenuItemView()
                    }
                }
            }
            .alert("극장 변경", isPresented: $isTheaterNoticePresented) {
                Button("강남") { selectedBranch = "강남" }
                Button("홍대") { selectedBranch = "홍대" }
                Button("신촌") { selectedBranch = "신촌" }
                Button("취소", role: .cancel) {}
            } message: {
                Text("일단 지금은 선택한 지점명만 화면에 반영합니다")
            }
        }
    }

    private var logoHeader: some View {
        HStack {
            Image("mobileOrderMeboxLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 149, height: 30)

            Spacer()
        }
        .padding(.leading, 16)
        .padding(.trailing, 20)
        .padding(.top, 1)
        .padding(.bottom, 17)
    }
}

private struct MenuCarouselSection: View {
    let title: String
    let subtitle: String
    let items: [MenuItemModel]
    let onSelect: (MenuItemModel) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.pretendardBold22)
                    .foregroundStyle(Color(.black))

                Text(subtitle)
                    .font(.pretendardRegular12)
                    .foregroundStyle(Color(.gray04))
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(items) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            MenuItemCardView(item: item)
                                .frame(width: 158)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 230)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MissingMenuItemView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 42))
                .foregroundStyle(Color(.purple03))

            Text("상품을 찾을 수 없어요")
                .font(.pretendardBold18)
                .foregroundStyle(Color(.black))

            Text("목록에서 다시 선택해주세요.")
                .font(.pretendardMedium14)
                .foregroundStyle(Color(.gray04))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.white))
    }
}

#Preview {
    MobileOrderView()
        .environment(NavigationRouter<MobileOrderRoute>())
}
