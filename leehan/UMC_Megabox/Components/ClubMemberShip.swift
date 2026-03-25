//
//  ClubMemberShip.swift
//  leehan
//
//  Created by 이한결 on 3/25/26.
//

import SwiftUI

struct ClubMemberShip: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.black)
            .overlay(
                HStack {
                    Text("클럽 멤버십 >")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(.white)
                        .padding(.leading, 10)
                    Spacer()
                }
            ).frame(height: 46)
    }
}

#Preview {
    ClubMemberShip()
}
