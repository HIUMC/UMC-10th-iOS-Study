//
//  DIContainer.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
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
    var reservationRouter = NavigationRouter<ReservationRoute>()
    var mobileOrderRouter = NavigationRouter<MobileOrderRoute>()

    // 로그아웃 시 전체 초기화
    func resetAll() {
        homeRouter.reset()
        myPageRouter.reset()
        reservationRouter.reset()
        mobileOrderRouter.reset()
        selectedTab = 0
    }
}
