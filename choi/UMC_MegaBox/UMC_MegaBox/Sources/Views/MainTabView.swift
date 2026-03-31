import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house.fill") {
                HomeView()
            }

            Tab("마이페이지", systemImage: "person.fill") {
                NavigationStack {
                    MyPageView()
                }
            }
        }
        .tint(Color(.purple03))
    }
}

#Preview {
    MainTabView()
}
