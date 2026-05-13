//
//  Button2.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct Button2: View {
    var text: String
    var onTap: () -> Void
    var isInfoClicked: Bool = true
    var body: some View {
        Button( action: { onTap() } ) {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(maxWidth: .infinity)
                .overlay(
                    VStack {
                        Text(text)
                            .font(.PretendardBold(size: 18))
                            .foregroundStyle(isInfoClicked ? .black : .gray02)
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 2)
                            .foregroundStyle(isInfoClicked ? .black : .gray02)
                    })
            
        }
    }
}

#Preview {
    Button2(text: "상세정보", onTap: { })
}
