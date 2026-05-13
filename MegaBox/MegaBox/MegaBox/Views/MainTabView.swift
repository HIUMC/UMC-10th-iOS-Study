//
//  TabView.swift
//  MegaBox
//
//  Created by 김민지 on 4/1/26.
//

import SwiftUI

struct MainTabView: View {
    // 현재 어떤 탭이 선택되었는지 저장하는 변수 (0: 홈, 1: 마이페이지)
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            //   빈 홈 화면 연결
            HomeView()
                .tabItem {
                    // 선택되었을 때와 안 되었을 때 아이콘 구분
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("홈")
                }
                .tag(0)
            
            // 마이페이지 연결
            MyPageView()
                .tabItem {
                    // 선택되었을 때(person.fill)와 안 되었을 때(person) 아이콘 구분
                    Image(systemName: selectedTab == 1 ? "person.fill" : "person")
                    Text("마이페이지")
                }
                .tag(1)
        }
    }
}

#Preview {
    MainTabView()
}
