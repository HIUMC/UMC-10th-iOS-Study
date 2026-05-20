//
//  InfoText.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct InfoText: View {
    var title: String
    var content: String
    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.PretendardSemiBold(size: 13))
                .foregroundStyle(.gray04)
            
            Text(content)
                .font(.PretendardSemiBold(size: 13))
                .foregroundStyle(.black)
            
            Spacer()
        }
    }
}
