//
//  Routes.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//


import SwiftUI
import Observation


enum HomeRoute: Hashable {
    case movieDetail(MovieModel)
}

enum MyPageRoute: Hashable {
    case profileManage
}

enum ReservationRoute: Hashable {
    case seatSelection(MovieModel, String, TimeTableModel, CalendarDay)
}

enum MobileOrderRoute: Hashable {
    case menuDetail(MenuItemModel)
}
