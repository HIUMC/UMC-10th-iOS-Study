//
//  DIContainer.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/31/26.
//

import SwiftUI
import Observation

@Observable
class DIContainer {
    // 탭 선택 상태
    var selectedTab: Int = 0

    // 앱에서 사용할 라우터들
    var homeRouter = NavigationRouter<HomeRoute>()
    var myPageRouter = NavigationRouter<MyPageRoute>()

    // 로그아웃 시 전체 초기화
    func resetAll() {
        homeRouter.reset()
        myPageRouter.reset()
        selectedTab = 0
    }
}

