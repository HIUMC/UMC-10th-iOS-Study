import SwiftUI

public struct LoginView: View {
    @State private var loginVM = LoginViewModel()  // 소유
    
    @AppStorage("id") private var id: String = ""
    @AppStorage("pwd") private var pwd: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

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
        @Bindable var vm = loginVM

        return VStack(spacing: 30) {
            // 아이디 영역
            VStack(alignment: .leading, spacing: 10) {
                // Text를 TextField로 변경하고 idText 변수와 바인딩
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
                // ViewModel → AppStorage에 저장
                id = loginVM.loginModel.id
                pwd = loginVM.loginModel.pwd
                isLoggedIn = true
                print("로그인 시도 - ID: \(loginVM.loginModel.id), PW: \(loginVM.loginModel.pwd)")
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
}
