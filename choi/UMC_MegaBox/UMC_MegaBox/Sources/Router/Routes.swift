//
//  Route.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/31/26.
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
    case seatSelection(MovieModel, String, ShowtimeModel)  // movie, theaterBranch, showtime
}
