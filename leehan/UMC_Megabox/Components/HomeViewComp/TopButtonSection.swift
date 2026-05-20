//
//  TopButtonSection.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct TopButtonSection: View {
    var body: some View {
        HStack {
            Button( action: { } ) {
                Text("홈")
                    .font(.PretendardSemiBold(size: 24))
                    .foregroundStyle(.black)
                    .padding(.trailing, 20)
            }
            
            Button( action: { } ) {
                Text("이벤트")
                    .font(.PretendardSemiBold(size: 24))
                    .foregroundStyle(.gray04)
                    .padding(.trailing, 20)
            }
            
            Button( action: { } ) {
                Text("스토어")
                    .font(.PretendardSemiBold(size: 24))
                    .foregroundStyle(.gray04)
                    .padding(.trailing, 20)
            }
            
            Button( action: { } ) {
                Text("선호극장")
                    .font(.PretendardSemiBold(size: 24))
                    .foregroundStyle(.gray04)
            }
            
            Spacer()
        }
    }
}

#Preview {
    TopButtonSection()
}
