//
//  Route.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/31/26.
//


import Foundation


enum HomeRoute: Hashable {
    case movieDetail(MovieModel)
}

enum MyPageRoute: Hashable {
    case profileManage
}

/// 좌석 선택 화면에 전달할 파라미터를 구조체로 묶어 가독성 향상
struct SeatSelectionParams: Hashable {
    let movie: MovieModel
    let theaterBranch: String
    let showtime: ShowtimeModel
    let selectedDate: CalendarDay
}

enum ReservationRoute: Hashable {
    case seatSelection(SeatSelectionParams)
}
