import SwiftUI

struct MainTabView: View {
    
    //부모(App)가 넘겨준 DIContainer 받아오기
    @Environment(DIContainer.self) private var container
    
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house") {
                HomeView()
                //DIContainer 안에서 '홈 라우터'만 꺼내서 홈 뷰에 주입
                    .environment(container.homeRouter)
            }
            Tab("바로 예매", systemImage: "play.laptopcomputer") {
                ReservationView()
            }
            
            Tab("모바일 오더", systemImage: "popcorn") {
                MobileOrderView()
            }
            
            Tab("마이페이지", systemImage: "person") {
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
