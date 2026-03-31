//
//  Route.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/31/26.
//


import SwiftUI
import Observation

enum Route: Hashable {
    case profileManage           // 마이페이지 -> 회원정보 관리
    case movieDetail(title: String) // 홈 -> 영화 상세 정보 (추후 영화 이름을 전달받음)
}
