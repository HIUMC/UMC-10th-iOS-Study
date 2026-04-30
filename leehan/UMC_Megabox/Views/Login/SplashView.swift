//
//  SplashView.swift
//  leehan
//
//  Created by 이한결 on 3/18/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        /// ZStack을 이용해 배경에 하얀 Rectangle을 넣어주고,
        /// ignoreSafeArea 수정자를 이용해 Dark mode에서도 변화 없게 구현
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.white)
                .ignoresSafeArea()
            
            Image("logo_megabox")
                .scaledToFit()
        }
    }
}

#Preview {
    SplashView()
}
