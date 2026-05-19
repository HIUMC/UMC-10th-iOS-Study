//
//  SplashView.swift
//  MegaBox
//
//  Created by 김민지 on 3/31/26.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @State private var isFinished = false

    var body: some View {
        Group {
            if isFinished {
                Root()
            } else {
                ZStack {
                    Color.white
                        .ignoresSafeArea()

                    VStack {
                        Image(.megaboxLogo1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 249, height: 84)
                    }
                }
            }
        }
        .task {
            guard !isFinished else { return }
            try? await Task.sleep(for: .seconds(1.2))
            isFinished = true
        }
    }
}

#Preview {
    SplashView()
}
