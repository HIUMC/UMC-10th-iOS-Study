import SwiftUI

struct SplashView: View {
    // ⭐️ 핵심: "나 이제 끝났어!"라고 부모(App)한테 알려줄 바인딩 변수
    @Binding var isFinished: Bool
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image(.meboxLogo1)
                .resizable() // 크기 조절을 위해 추가
                .scaledToFit()
                .frame(width: 249, height: 84)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    // ⭐️ 1.5초 뒤에 부모의 스위치를 켭니다!
                    self.isFinished = true
                }
            }
        }
    }
}
