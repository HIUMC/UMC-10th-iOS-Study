import SwiftUI
import KakaoSDKUser
import KakaoSDKAuth

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        VStack {
            // 1. 네비게이션 섹션
            navigationSection
            
            Spacer().frame(height: 170)
            
            // 2. 로그인 섹션 (Input + Login 버튼 + 소셜)
            loginSection
            
            Spacer()
            
            // 3. 하단 로고
            umcLogo
        }
        .padding(.horizontal)
        // 뷰모델의 로그인 성공 상태를 AppStorage에 반영
        .onChange(of: viewModel.isLoggedIn) { _, newValue in
            isLoggedIn = newValue
        }
        // 로딩 중일 때 화면 덮기
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView("로그인 중...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
        }
        .alert("로그인 실패", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if $0 == false { viewModel.errorMessage = nil } }
        )) {
            Button("확인", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // --- UI 컴포넌트들 ---

    // navigation 섹션 - 글자를 가운데로 정렬
        private var navigationSection: some View {
            HStack {
                Spacer() // 왼쪽에 공간 추가
                
                Text("로그인")
                    .font(.megaboxExtraBold24)
                
                Spacer() // 오른쪽에 공간 추가
            }
        }

    private var loginSection: some View {
        VStack {
            inputSection
            loginButton
            signUpSection
            socialSection // 여기가 카카오 버튼이 있는 곳!
        }
    }

    private var inputSection: some View {
        VStack(alignment: .leading) {
            TextField("아이디", text: $viewModel.loginData.id)
                .foregroundColor(.megaGraygray03)
            Divider().padding(.bottom, 20)
            
            SecureField("비밀번호", text: $viewModel.loginData.pw)
                .foregroundColor(.megaGraygray03)
            Divider()
        }
        .padding(.bottom, 100)
    }

    private var loginButton: some View {
        Button(action: {
            viewModel.login()
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
            Image(.loginBtn) // 네이버 (기존 이미지)
            
            Spacer()
            // 🔥 카카오 로그인 버튼 (이미지를 버튼으로 감쌈)
            Button(action: {
                viewModel.handleKakaoLogin()
            }) {
                Image(.loginBtn1) // 기존에 쓰시던 카카오 동그라미 이미지
                    .resizable()
                    .frame(width: 48, height: 48) // 이미지 크기에 맞게 조절하세요
            }
            
            Spacer()
            Image(.loginBtn2) // 애플 (기존 이미지)
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
