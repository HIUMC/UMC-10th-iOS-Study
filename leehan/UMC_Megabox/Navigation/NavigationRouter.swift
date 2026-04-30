//
//  NavigationRouter.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

@Observable
class NavigationRouter {
    var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty { path.removeLast() }
    }
    
    func navigateToRoot() {
        path = NavigationPath()
    }
}
