import SwiftUI

public struct LoginView: View {
    public init() {}
    
    public var body: some View {
        VStack() { // 각 하위 뷰 사이의 간격
            
            customNavBar
            Spacer()
            VStack(spacing: 30) {
                inputFieldView
                loginButtonView
                socialLoginView
            }
            .padding(.horizontal, 20) // 양옆 여백
            promoImageView
                .padding(.top,30)
                .padding(.bottom, 250)
                
        }
    }
    
    // MARK: - 하위 뷰 (Sub-views)
    
    private var customNavBar: some View {
        HStack {
            Spacer()
            Text("로그인")
                .font(.pretendardSemiBold24) // 프로젝트에 정의된 폰트 익스텐션 사용
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.top, 20)
    }
    
    private var inputFieldView: some View {
        VStack(spacing: 30) {
            // 아이디 영역
            VStack(alignment: .leading, spacing: 10) {
                Text("아이디")
                    .font(.pretendardMedium16)
                    .foregroundColor(.gray)
                Divider()
                    .background(Color(red: 0.84, green: 0.84, blue: 0.84))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("비밀번호")
                    .font(.pretendardMedium16)
                    .foregroundColor(.gray)
                Divider()
                    .background(Color(red: 0.84, green: 0.84, blue: 0.84))
            }
        }
    }
    
    private var loginButtonView: some View {
        VStack(spacing: 20) {
            // 로그인 버튼
            HStack {
                Spacer()
                Text("로그인")
                    .font(.pretendardBold18)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 15)
            .background(Color(red: 0.4, green: 0.05, blue: 0.85))
            .cornerRadius(10)
            
            Text("회원가입")
                .font(.pretendardMedium13)
                .foregroundColor(.gray)
        }
    }
    
    private var socialLoginView: some View {
        HStack(spacing: 80) {
            Image("LoginBtn 1") // 네이버
                .resizable()
                .frame(width: 40, height: 40)
            Image("LoginBtn 2") // 카카오톡
                .resizable()
                .frame(width: 40, height: 40)
            Image("LoginBtn")   // 애플
                .resizable()
                .frame(width: 40, height: 40)
        }
        .padding(.top, 10)
    }
    
    private var promoImageView: some View {
        Image("umc")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .frame(height: 103)
            .clipped()
    }
}

#Preview {
    LoginView()
}
