//
//  MainTabView.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var router = NavigationRouter()
    @State private var homeVM = HomeViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $router.path) {
                HomeView()
                    .setupNavigationDestination()
            }.tabItem {
                Image(systemName: "house")
                    
                Text("홈")
            }
            .tag(0)
            
            NavigationStack(path: $router.path) {
                TicketView()
                    .setupNavigationDestination()
            }.tabItem {
                Image(systemName: "play.laptopcomputer")
                    
                Text("바로 예매")
            }
            .tag(1)
            
            NavigationStack(path: $router.path) {
                OrderView()
                    .setupNavigationDestination()
            }.tabItem {
                Image(systemName: "popcorn")
                    
                Text("모바일 오더")
            }
            .tag(2)
            
            NavigationStack(path: $router.path) {
                ProfileView()
                    .setupNavigationDestination()
            }.tabItem {
                Image(systemName: "person")
                Text("마이 페이지")
            }
            .tag(3)
        }.tint(.gray08)
            .environment(router)
            .environment(homeVM)
            .onChange(of: selectedTab) {
                /// onChange를 이용해 다른 탭으로 이동 시 router 초기화
                /// 초기화되는 과정이 사용자에게 모두 보이기 때문에
                /// DispatchQueue를 이용해 딜레이를 주어
                /// 마치 백그라운드에서 router 초기화가 일어나는 것처럼 구현
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    router.navigateToRoot()
                }
            }
    }
}

// MARK: navigationDestination으로 이용할 경로 목록을 하나의 함수로 정의
extension View {
    func setupNavigationDestination() -> some View {
        self.navigationDestination(for: Route.self) { route in
            switch route {
            case .home:
                HomeView()
            case .ticket:
                TicketView()
            case .order:
                OrderView()
            case .profile:
                ProfileView()
            case .editProfile:
                ManageUserInfoView()
            case .movieSpec(let spec):
                MovieSpecView(spec: spec)
            }
        }
    }
}

#Preview {
    MainTabView()
}
