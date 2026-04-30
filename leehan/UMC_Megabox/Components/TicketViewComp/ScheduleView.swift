//
//  ScheduleView.swift
//  leehan
//
//  Created by 이한결 on 4/30/26.
//

import SwiftUI

struct ScheduleView: View {
    let theaterInfo: TheaterScheduleGroup
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
    
    var body: some View {
        VStack(spacing: 30) {
            
            // MARK: 상단 영화관 이름: 홍대, 강남, 신촌 ...
            HStack {
                Text(theaterInfo.theater.name)
                    .font(.PretendardBold(size: 18))
                    .foregroundStyle(.black)
                Spacer()
            }
            
            // MARK: 상영관 이름 + 상영 스케줄을 이중 ForEach로 구현
            /// 첫번째 ForEach는 상영관 이름에 대한 ForEach
            /// 두번째 ForEach는 각 상영관에 대한 상영 스케줄의 ForEach
            ForEach(theaterInfo.screenGroups) { screen in
                HStack {
                    Text(screen.screenName)
                        .font(.PretendardBold(size: 18))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("2D") // 하드코딩
                        .font(.PretendardSemiBold(size: 14))
                        .foregroundStyle(.black)
                }
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(screen.schedules) { schedule in
                        ScheduleCard(scheduleInfo: schedule)
                    }
                }
            }
        }
    }
}

#Preview {
    // 1. 제일 작은 단위인 '스케줄' 더미 데이터를 여러 개 만듭니다.
    let schedule1 = ScheduleModel(
        movieId: UUID(), theaterId: UUID(), date: Date(),
        startTime: "11:30", endTime: "13:58", screenName: "르 리클라이너 1관",
        totalSeats: 116, bookedSeats: 109
    )
    
    let schedule2 = ScheduleModel(
        movieId: UUID(), theaterId: UUID(), date: Date(),
        startTime: "14:20", endTime: "16:48", screenName: "르 리클라이너 1관",
        totalSeats: 116, bookedSeats: 19
    )
    
    let schedule3 = ScheduleModel(
        movieId: UUID(), theaterId: UUID(), date: Date(),
        startTime: "17:05", endTime: "19:28", screenName: "르 리클라이너 1관",
        totalSeats: 116, bookedSeats: 1
    )
    
    let schedule4 = ScheduleModel(
        movieId: UUID(), theaterId: UUID(), date: Date(),
        startTime: "17:05", endTime: "19:28", screenName: "르 리클라이너 1관",
        totalSeats: 116, bookedSeats: 1
    )
    
    let schedule5 = ScheduleModel(
        movieId: UUID(), theaterId: UUID(), date: Date(),
        startTime: "17:05", endTime: "19:28", screenName: "르 리클라이너 1관",
        totalSeats: 116, bookedSeats: 1
    )
    
    // 2. 스케줄들을 모아서 '상영관 그룹' 바구니에 담습니다.
    let screenGroup = ScreenScheduleGroup(
        screenName: "르 리클라이너 1관",
        schedules: [schedule1, schedule2, schedule3, schedule4, schedule5]
    )
    
    // 3. 상영관 그룹들을 모아서 최종 '극장 그룹' 바구니에 담습니다.
    let theaterGroup = TheaterScheduleGroup(
        theater: TheaterModel(name: "강남"),
        screenGroups: [screenGroup]
    )
    
    // 4. 완성된 극장 그룹 데이터를 뷰에 전달하여 화면을 그립니다!
    // (프리뷰에서 예쁘게 보기 위해 화면 양옆에 살짝 여백(.padding)을 줍니다.)
    return ScheduleView(theaterInfo: theaterGroup)
        .padding()
}
