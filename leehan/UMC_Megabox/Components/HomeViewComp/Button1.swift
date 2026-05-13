//
//  Button1.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct Button1: View {
    var text: String
    var isMovieChartSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button( action: { onTap() } ) {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 84, height: 38)
                .foregroundStyle(isMovieChartSelected ? .gray08 : .gray02)
                .overlay(
                    Text(text)
                        .font(.PretendardSemiBold(size: 15))
                        .foregroundStyle(isMovieChartSelected ? .white : .gray04)
                )
        }
    }
}
