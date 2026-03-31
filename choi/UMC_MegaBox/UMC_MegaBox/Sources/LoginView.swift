import SwiftUI

public struct LoginView: View {
    // 사용자가 입력하는 아이디와 비밀번호를 추적하기 위한 상태 변수
    @State private var idText: String = ""
    @State private var passwordText: String = ""
    
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
            
            promoImageView
                .padding(.top, 30)
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
        VStack(spacing: 30) {
            // 아이디 영역
            VStack(alignment: .leading, spacing: 10) {
                // Text를 TextField로 변경하고 idText 변수와 바인딩
                TextField("아이디", text: $idText)
                    .font(.pretendardMedium16)
                    .foregroundColor(Color(.gray03))
                    .autocapitalization(.none) // 아이디 입력 시 첫 글자 대문자 자동 변환 방지
                Divider()
                    .background(Color(.gray02))
            }
            
            // 비밀번호 영역
            VStack(alignment: .leading, spacing: 10) {
                // 비밀번호는 마스킹 처리가 필요하므로 SecureField를 사용
                SecureField("비밀번호", text: $passwordText)
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
                // 실제 로그인 로직이 들어갈 자리. 임시로 콘솔에 출력하도록 작성
                 print("로그인 시도 - ID: \(idText), PW: \(passwordText)")
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
