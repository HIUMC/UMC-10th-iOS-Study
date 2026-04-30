//
//  ScheduleCard.swift
//  leehan
//
//  Created by 이한결 on 4/30/26.
//

import SwiftUI

struct ScheduleCard: View {
    let scheduleInfo: ScheduleModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
                .foregroundStyle(.gray02)
                .frame(width: 80, height: 77)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(scheduleInfo.startTime)
                    .font(.PretendardBold(size: 18))
                    .foregroundStyle(.black)
                
                Text("~\(scheduleInfo.endTime)")
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray03)
                
                HStack(spacing: 0) {
                    Text("\(scheduleInfo.bookedSeats)")
                        .font(.PretendardSemiBold(size: 14))
                        .foregroundStyle(.purple03)
                    
                    Text("/\(scheduleInfo.totalSeats)")
                        .font(.PretendardSemiBold(size: 14))
                        .foregroundStyle(.gray03)
                }
            }
        }
    }
}

#Preview {
    // 1. 프리뷰 화면에서 보여줄 임시 더미 데이터를 생성합니다.
    let dummySchedule = ScheduleModel(
        movieId: UUID(),
        theaterId: UUID(),
        date: Date(),
        startTime: "11:30",
        endTime: "13:58",
        screenName: "르 리클라이너 1관",
        totalSeats: 116,
        bookedSeats: 109
    )
    
    // 2. 생성한 더미 데이터를 ScheduleCard에 주입하여 렌더링합니다.
    return ScheduleCard(scheduleInfo: dummySchedule)
}
