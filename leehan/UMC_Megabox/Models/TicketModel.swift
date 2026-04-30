//
//  TicketModel.swift
//  leehan
//
//  Created by 이한결 on 4/29/26.
//

import Foundation

struct TheaterModel: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
}

struct ScheduleModel: Identifiable, Hashable {
    let id: UUID = UUID()
    let movieId: UUID
    let theaterId: UUID
    
    let date: Date
    let startTime: String
    let endTime: String
    
    let screenName: String
    let totalSeats: Int
    var bookedSeats: Int
}

// MARK: 뷰모델에서 사용할 그루핑 모델들
// 극장마다의 데이터
struct TheaterScheduleGroup: Identifiable {
    let id = UUID()
    let theater: TheaterModel
    let screenGroups: [ScreenScheduleGroup]
}

// 상영관마다의 영화스케줄 데이터
struct ScreenScheduleGroup: Identifiable {
    let id = UUID()
    let screenName: String
    let schedules: [ScheduleModel]
}
