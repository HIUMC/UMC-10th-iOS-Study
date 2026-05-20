//
//  QuickActionButton.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI

struct QuickActionButton: View {
    let imageName: String
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 66, height: 67)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
}

#Preview {
    HStack {
        QuickActionButton(imageName: "영화관예매")
        QuickActionButton(imageName: "극장별예매")
    }
}
