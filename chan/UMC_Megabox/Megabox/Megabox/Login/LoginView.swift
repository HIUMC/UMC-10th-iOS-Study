import SwiftUI

struct LoginView: View {
    // 사용자가 입력할 텍스트를 저장할 공간 (State)를 먼저 만들어야 한다.
    @State private var loginViewModel = LoginViewModel()
    
    @AppStorage("savedId") private var savedId: String = "abc"
    @AppStorage("savedPw") private var savedPw: String = "123"
    
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
            VStack { // 1. 모든 요소를 이 큰 바구니 하나에 담으세요!
                navigationSection
                
                Spacer()
                    .frame(height: 170)
                    
                loginSection
                
                // 2. umcLogo를 VStack 안으로 넣고,
                // 그 위에 유동적인 Spacer를 하나 더 넣으면 로고가 맨 밑으로 슉 내려갑니다.
                Spacer()
                
                umcLogo
            }
            .padding(.horizontal)
        }
    
    // navigation 섹션
    private var navigationSection : some View{
        HStack(){
            Text("로그인")
                .font(.megaboxExtraBold24)
        }
    }


    // 로그인 섹션 (input창, 로그인 버튼, 회원가입, 소셜)
    private var loginSection : some View {
        VStack() {
            inputSection
            loginButton
            signUpSection
            socialSection
        }
    }

    //Input Section : 아이디, 비밀번호 TextField
    private var inputSection : some View{
        VStack(alignment: .leading) {
            TextField("아이디", text: $loginViewModel.loginData.id)
                .foregroundColor(.megaGraygray03)
            Divider()
                .padding(.bottom, 20)
            
            SecureField("비밀번호", text : $loginViewModel.loginData.pw)
                .foregroundColor(.megaGraygray03)
            Divider()
        }.padding(.bottom,100)
    }
    // LoginButton : 보라색 로그인 창
    
    private var loginButton: some View {
            Button(action: {
                // 아이디와 비밀번호 저장
                savedId = loginViewModel.loginData.id
                savedPw = loginViewModel.loginData.pw
                
                // ⭐️ 3. 로그인 성공 처리 (여기에 조건문을 달아도 좋고, 일단 버튼 누르면 성공하게 하려면 바로 true!)
                // 예: 만약 아이디가 비어있지 않다면 로그인 성공으로 간주
                if !savedId.isEmpty && !savedPw.isEmpty {
                    print("로그인 성공: 탭뷰로 이동합니다.")
                    isLoggedIn = true
                }
                
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
    // SignUpSection : 회원가입
    private var signUpSection : some View{
        Text("회원가입")
            .foregroundStyle(.megaGraygray03)
            .font(.megaboxMedium16)
            .padding(.bottom, 20)
    }
    // SocialSection : 네이버, 카카오톡, 애플
    private var socialSection : some View{
        HStack(){
            Spacer()
            Image(.loginBtn)
            Spacer()
            Image(.loginBtn1)
            Spacer()
            Image(.loginBtn2)
            Spacer()
            
        }.padding(.bottom, 20)
    }

    // umcLogo : UMC 로고 넣는 곳
    private var umcLogo : some View {
        Image(.umcLogo)
            .resizable()
            .scaledToFit()
            .padding(.horizontal)
    }
}

#Preview {
    LoginView()
}
