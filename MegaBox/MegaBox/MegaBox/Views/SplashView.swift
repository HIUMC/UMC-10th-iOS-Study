//
//  SplashView.swift
//  MegaBox
//
//  Created by 김민지 on 3/31/26.
//

import Foundation
import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white // 배경색을 전체 화면에 꽉 채움
                .ignoresSafeArea()  // 전체 화면 채우기
            
            // 로고 이미지 배치
            VStack {
                Image(.megaboxLogo1)
                    .resizable()    // 프레임 크기에 맞게 이미지 조절 가능하게 설정
                    .scaledToFit()  // 비율 유지
                    .frame(width: 249, height: 84)  // 원하는 로고 너비 지정
            }
        }
    }
}

#Preview {
    SplashView()
}
