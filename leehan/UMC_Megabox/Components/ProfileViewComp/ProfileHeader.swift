//
//  ProfileHeader.swift
//  leehan
//
//  Created by 이한결 on 3/25/26.
//

import SwiftUI

struct ProfileHeader: View {
    var name: String = "사용자"
    var point: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(name)님")
                    .font(.PretendardBold(size: 24))
                    .foregroundStyle(.black)
                Image("icon_welcome")
                
                Spacer()
            }.frame(height: 30)
            
            HStack {
                Text("멤버쉽 포인트")
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.gray04)
                Text("\(point)p")
                    .font(.PretendardMedium(size: 14))
                    .foregroundStyle(.black)
                
                Spacer()
            }.frame(height: 20)
        }
    }
}

#Preview {
    ProfileHeader()
}
