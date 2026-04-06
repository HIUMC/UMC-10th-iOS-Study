import SwiftUI

struct MainTabView: View {
    
    //부모(App)가 넘겨준 DIContainer 받아오기
    @Environment(DIContainer.self) private var container
    
    var body: some View {
        @Bindable var bindableContainer = container

        TabView(selection: $bindableContainer.selectedTab) {
            Tab("홈", systemImage: "house", value: 0) {
                HomeView()
                    .environment(container.homeRouter)
            }
            Tab("바로 예매", systemImage: "play.laptopcomputer", value: 1) {
                ReservationView()
            }

            Tab("모바일 오더", systemImage: "popcorn", value: 2) {
                MobileOrderView()
            }

            Tab("마이페이지", systemImage: "person", value: 3) {
                MyPageView()
                    .environment(container.myPageRouter)
            }
        }
        .tint(Color(.purple03))
    }
}

#Preview {
    MainTabView()
        .environment(DIContainer())
}
