import SwiftUI

struct LoginView: View {
    // 1. 뷰모델 연결
    @State private var loginViewModel = LoginViewModel()
    
    // 2. 화면 전환용 상태값 (이건 공유해야 하니 AppStorage 유지)
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack {
            navigationSection
            
            Spacer()
                .frame(height: 170)
            
            loginSection
            
            Spacer()
            
            umcLogo
        }
        .padding(.horizontal)
        // ✅ 뷰모델의 로그인 상태가 true가 되면 AppStorage도 true로 바꿔서 화면 전환 시킴
        .onChange(of: loginViewModel.isLoggedIn) { _, newValue in
            if newValue {
                self.isLoggedIn = true
            }
        }
    }
    
    // MARK: - 하위 뷰 섹션들
    
    private var navigationSection: some View {
        HStack {
            Text("로그인")
                .font(.megaboxExtraBold24)
        }
    }

    private var loginSection: some View {
        VStack {
            inputSection
            loginButton
            signUpSection
            socialSection
        }
    }

    private var inputSection: some View {
        VStack(alignment: .leading) {
            TextField("아이디", text: $loginViewModel.loginData.id)
                .foregroundColor(.megaGraygray03)
            Divider()
                .padding(.bottom, 20)
            
            SecureField("비밀번호", text: $loginViewModel.loginData.pw)
                .foregroundColor(.megaGraygray03)
            Divider()
        }
        .padding(.bottom, 100)
    }

    private var loginButton: some View {
        Button(action: {
            // ✅ 뷰모델에 로그인 로직(키체인 저장 등)을 시킵니다.
            loginViewModel.login()
        }) {
            Text("로그인")
                .font(.megaboxBold20)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.megaPurple)
                .cornerRadius(10)
        }
        .padding(.bottom, 20)
    }

    private var signUpSection: some View {
        Text("회원가입")
            .foregroundStyle(.megaGraygray03)
            .font(.megaboxMedium16)
            .padding(.bottom, 20)
    }

    private var socialSection: some View {
        HStack {
            Spacer()
            Image(.loginBtn)
            Spacer()
            Image(.loginBtn1)
            Spacer()
            Image(.loginBtn2)
            Spacer()
        }
        .padding(.bottom, 20)
    }

    private var umcLogo: some View {
        Image(.umcLogo)
            .resizable()
            .scaledToFit()
            .padding(.horizontal)
    }
}

#Preview {
    LoginView()
}
