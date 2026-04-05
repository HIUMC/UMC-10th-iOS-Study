import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 1. 홈 탭 (상단 로고를 위해 NavigationStack 포함)
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("홈", systemImage: "house.fill")
            }
            .tag(0)
            
            // 2. 바로 예매
            Text("바로 예매")
                .tabItem {
                    Label("바로 예매", systemImage: "play.laptopcomputer")
                }
                .tag(1)
            
            // ⭐️ 3. 모바일 오더 (여기가 빠졌었습니다!)
            Text("모바일 오더")
                .tabItem {
                    Label("모바일 오더", systemImage: "popcorn.fill")
                }
                .tag(2)
            
            // 4. 마이페이지
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("마이페이지", systemImage: "person.fill")
            }
            .tag(3)
        }
        
    }
}
