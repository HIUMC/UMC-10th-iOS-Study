//
//  MegaboxApp.swift
//  Megabox
//
//  Created by chanhyeok on 3/18/26.
//

import SwiftUI

@main
struct MegaboxApp: App {
    @State private var isSplashScreenFinished = false // 로고 화면 끝났는지?
    
    var body: some Scene {
        WindowGroup {
            if isSplashScreenFinished {
                MainRootView()
            }else{
                //앱 켜지자마자 딲 한 번만 보여줄 화면
                SplashView(isFinished: $isSplashScreenFinished)
            }
        }
    }
}

#Preview {
    // 실제 앱이 구동되는 전체 흐름(Splash -> Root)을 미리보기로 확인!
    RootPreviewHelper()
}

// 프리뷰를 위해 잠시 만든 가짜 앱 시작점
struct RootPreviewHelper: View {
    @State private var isSplashScreenFinished = false
    
    var body: some View {
        if isSplashScreenFinished {
            MainRootView()
        } else {
            SplashView(isFinished: $isSplashScreenFinished)
        }
    }
}
