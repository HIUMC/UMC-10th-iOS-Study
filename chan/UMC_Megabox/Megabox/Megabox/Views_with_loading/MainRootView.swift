import SwiftUI

struct MainRootView: View {
    // 뷰모델을 통해 금고 상태를 확인합니다.
    @State private var loginViewModel = LoginViewModel()
    
    // 화면 전환을 위한 트리거로만 사용합니다.
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            // ✅ 앱이 나타날 때 키체인을 체크해서 isLoggedIn 값을 동기화합니다.
            loginViewModel.checkAutoLogin()
            self.isLoggedIn = loginViewModel.isLoggedIn
        }
        .onChange(of: loginViewModel.isLoggedIn) { _, newValue in
            // ✅ 로그인/로그아웃 액션이 발생하면 화면을 갈아줍니다.
            self.isLoggedIn = newValue
        }
    }
}
#Preview{
    MainRootView()
}
