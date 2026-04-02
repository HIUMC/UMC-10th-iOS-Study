import SwiftUI

public struct LoginView: View {
    @Environment(AuthViewModel.self) private var authVM  // 인증 ViewModel (RootView에서 주입)

    public init() {}
    
    public var body: some View {

        VStack() {
            customNavBar
            Spacer()
            VStack(spacing: 30) {
                inputFieldView
                loginButtonView
                socialLoginView
            }
            .padding(.horizontal, 20) // 양옆 여백
            
            Spacer()
            promoImageView
                .padding(.bottom, 250)
        }
}
    
    // MARK: - 하위 뷰 (Sub-views)
    
    private var customNavBar: some View {
        HStack {
            Spacer()
            Text("로그인")
                .font(.pretendardSemiBold24)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.top, 20)
    }
    
    private var inputFieldView: some View {
        @Bindable var vm = authVM

        return VStack(spacing: 30) {
            // 아이디 영역
            VStack(alignment: .leading, spacing: 10) {
                TextField("아이디", text: $vm.loginModel.id)
                    .font(.pretendardMedium16)
                    .foregroundColor(Color(.gray03))
                    .autocapitalization(.none) // 아이디 입력 시 첫 글자 대문자 자동 변환 방지
                Divider()
                    .background(Color(.gray02))
            }
            
            // 비밀번호 영역
            VStack(alignment: .leading, spacing: 10) {
                SecureField("비밀번호", text: $vm.loginModel.pwd)
                    .font(.pretendardMedium16)
                    .foregroundColor(Color(.gray03))
                Divider()
                    .background(Color(.gray02))
            }
        }
    }
    
    private var loginButtonView: some View {

        VStack(spacing: 20) {
            // 로그인 버튼
            Button(action: {
                authVM.login()
            }) {
                HStack {
                    Spacer()
                    Text("로그인")
                        .font(.pretendardBold18)
                        .foregroundColor(Color(.white))
                    Spacer()
                }
                .padding(.vertical, 15)
                .background(Color(.purple03))
                .cornerRadius(10)
            }
            
            // 회원가입 버튼
            Button(action: {
                print("회원가입 화면으로 이동")
            }) {
                Text("회원가입")
                    .font(.pretendardMedium13)
                    .foregroundColor(Color(.gray03))
            }
        }
    }
    
    private var socialLoginView: some View {
        HStack(spacing: 80) {
            // 네이버 버튼
            Button(action: {
                print("네이버 로그인 클릭됨")
            }) {
                Image("LoginBtn 1")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            // 카카오 버튼
            Button(action: {
                print("카카오 로그인 클릭됨")
            }) {
                Image("LoginBtn 2")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            // 애플 버튼
            Button(action: {
                print("애플 로그인 클릭됨")
            }) {
                Image("LoginBtn")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.top, 10)
    }
    
    private var promoImageView: some View {
        Image("umc")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .frame(height: 103)
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
