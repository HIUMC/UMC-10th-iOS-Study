//
//  ProfileHeaderView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    @AppStorage("name") private var name: String = ""

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("\(name)님")
                        .font(.pretendardBold24)
                    
                    Text("WELCOME")
                        .font(.pretendardMedium14)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.28, green: 0.8, blue: 0.82))
                        .cornerRadius(12)
                }
                
                HStack(spacing: 4) {
                    Text("멤버십 포인트")
                        .font(.pretendardSemiBold14)
                        .frame(width:76, height:20)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Color(.gray04))
                    Text("포인트 값 입력")
                        .font(.pretendardMedium14)
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.trailing)
                    
                }
            }
            Spacer()
            
            // 회원정보 버튼
            Button(action: {}) {
                Text("회원정보")
                    .font(.pretendardSemiBold14)
                    .foregroundColor(.white)
                    .padding(8)
                    .frame(width: 72, alignment: .center)
                    .background(Color(.gray07))
                    .cornerRadius(14)

            }
            .padding(.horizontal, 10)

        }
        
    }
}
#Preview {
    ProfileHeaderView()
}
