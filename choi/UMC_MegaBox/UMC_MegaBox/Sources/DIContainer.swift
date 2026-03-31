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
    // 앱에서 사용할 라우터들
    var homeRouter = NavigationRouter()
    var myPageRouter = NavigationRouter()
}
