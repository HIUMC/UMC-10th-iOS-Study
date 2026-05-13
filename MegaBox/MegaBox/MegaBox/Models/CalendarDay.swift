//
//  CalendarModel.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//

import Foundation

struct DateItem: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let displayDay: String     // "4.1" 또는 "2"
    let displayWeekday: String // "오늘", "내일", "금"
    let isToday: Bool          // 상영 정보 노출 여부 결정용
}
