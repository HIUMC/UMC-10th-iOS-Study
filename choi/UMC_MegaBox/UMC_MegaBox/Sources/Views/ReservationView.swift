//
//  Reservation.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/31/26.
//

import SwiftUI

struct ReservationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("예매 화면")
                    .font(.pretendardBold24)
                    .foregroundColor(Color(.gray04))
                Text("여기에 예매 화면이 들어온다")
                    .font(.pretendardMedium14)
                    .foregroundColor(Color(.gray02))
                Spacer()
            }
        }
    }
}

#Preview {
    ReservationView()
}
