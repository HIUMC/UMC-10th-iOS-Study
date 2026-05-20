import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct MegaboxApp: App {
    @State private var isSplashScreenFinished = false
    
    init() {
        // 네이티브 앱 키 초기화
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isSplashScreenFinished {
                    MainRootView()
                } else {
                    SplashView(isFinished: $isSplashScreenFinished)
                }
            }
            // ⭐️ 이 부분이 핵심입니다!
            // 카카오톡이나 웹 브라우저 인증 후 앱으로 돌아올 때 이 코드가 실행되어야 합니다.
            .onOpenURL { url in
                print("DEBUG: 앱이 URL을 통해 열렸습니다: \(url)")
                
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                    print("DEBUG: 카카오 인증 URL 처리 완료")
                }
            }
        }
    }
}

#Preview {
    // 프리뷰가 시작될 때도 SDK 초기화가 필요할 수 있습니다.
    let _ = {
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeAppKey)
    }()
    
    return MegaboxAppViewPreviewHelper()
}

// 프리뷰를 위해 앱의 메인 흐름을 재현하는 헬퍼 뷰
struct MegaboxAppViewPreviewHelper: View {
    @State private var isSplashScreenFinished = false
    
    var body: some View {
        Group {
            if isSplashScreenFinished {
                MainRootView()
            } else {
                SplashView(isFinished: $isSplashScreenFinished)
            }
        }
        // 프리뷰 안에서도 URL 스킴 테스트가 필요할 경우를 대비
        .onOpenURL { url in
            print("Preview DEBUG: URL Opened - \(url)")
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
