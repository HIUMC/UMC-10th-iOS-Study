//
//  MainTabView.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var router = NavigationRouter()
    
    var body: some View {
        TabView {
            HomeView()
                    .tabItem {
                        Image(systemName: "house")
                            
                        Text("홈")
                    }
            
            TicketView()
                .tabItem {
                    Image(systemName: "play.laptopcomputer")
                        
                    Text("바로 예매")
                }
            
            OrderView()
                .tabItem {
                    Image(systemName: "popcorn")
                        
                    Text("모바일 오더")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("마이 페이지")
                }
        }.tint(.gray08)
    }
}

#Preview {
    MainTabView()
}
