//
//  Route.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import Foundation

enum Route: Hashable {
    case home
    case ticket // 바로예매
    case order
    case profile
    case editProfile
    case movieSpec(MovieModel)
}
