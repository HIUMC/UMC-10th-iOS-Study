//
//  dView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI

struct MyPageView: View {
    @Environment(NavigationRouter<MyPageRoute>.self) private var router

    var body: some View {
        // @Observable 매크로를 쓰는 클래스의 프로퍼티를 바인딩($) 하기 위해
        // @Bindable 래퍼를 사용
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.path) {
            VStack(spacing: 0) {
                // 프로필 헤더
                ProfileHeaderView()
                    .padding(.top, 20)
                    .padding(.horizontal, 25)
                
                // 클럽 멤버십 바
                ClubMembershipButton()
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                // 쿠폰 / 스토어 교환권 / 모바일 티켓
                StatsInfoView()
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                // 퀵 액션 버튼 4개
                QuickActionsRow()
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                Spacer()
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                switch route {
                case .profileManage:
                    ProfileManageView()
                }
            }
        }
    }
}

#Preview {
    MyPageView()
        .environment(NavigationRouter<MyPageRoute>())
        .environment(DIContainer())
        .environment(AuthViewModel())
}
