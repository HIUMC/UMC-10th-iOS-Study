import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house") {
                HomeView()
                
            }
            Tab("바로 예매", systemImage: "play.laptopcomputer") {
                ReservationView()
            }
            
            Tab("모바일 오더", systemImage: "popcorn") {
                MobileOrderView()
            }
            
            Tab("마이페이지", systemImage: "person") {
                MyPageView()
            }
        }
        .tint(Color(.purple03))
    }
}

#Preview {
    MainTabView()
}
