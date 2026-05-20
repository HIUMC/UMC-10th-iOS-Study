//
//  NaviationRouter.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//

import SwiftUI
import Observation

// <Destination: Hashable> : 어떤 타입이든 들어올 수 있음
@Observable
class NavigationRouter<Destination: Hashable> {
    var path = NavigationPath()

    // 화면 추가 (Push)
    func push(_ route: Destination) {
        path.append(route)
    }

    // 마지막 화면 제거 (Pop)
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    // 전체 초기화 (Root로 돌아가기)
    func reset() {
        path = NavigationPath()
    }
}
