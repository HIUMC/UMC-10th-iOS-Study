import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(){
            VStack(){ // 상단 콘텐츠
                navigationSection // navigationBar
                Spacer()
                inputSection    // 아이디, 비번 입력창
                loginSection  // 로그인 버튼
                signUpSection    // 회원가입 버튼
                socialLoginSection // 소셜 로그인
            }
            umcPoster       // UMC 포스터
            Spacer()
                .frame(height:330)
            
        }
    }
    
   
    }
private var navigationSection : some View{
    HStack(){
        Text("로그인")
            .font(.MegaboxExtraBold24)
    }
}

private var inputSection: some View {
    VStack(alignment:.leading, spacing : 20){
        Text("아이디")
            .foregroundColor(.gray)
        Divider()
            
        Text("비밀번호")
            .foregroundColor(.gray)
        Divider()
    }.frame(width : 408)
        .padding(.bottom, 60)
    }

private var loginSection: some View {
    Button(action: { print("Hi") }) {
        Text("로그인")
            .font(.MegaboxBold20)
            .foregroundColor(.white)
            .frame(width: 408, height: 54)
            .background(Color.megaPurple)
            .cornerRadius(10)
    }.padding(.bottom, 20)
}

private var signUpSection: some View {
    Text("회원가입")
        .font(.MegaboxMedium16)
        .foregroundColor(.gray)
        .padding(.bottom,20)
}

private var socialLoginSection: some View {
    HStack(){
        Image(.loginBtn)
        Spacer()
        Image(.loginBtn1)
        Spacer()
        Image(.loginBtn2)
    }.frame(width:266)
}
private var umcPoster : some View{
    Image(.umcLogo)
        .resizable()
        .frame(width:408,height:103)
}

#Preview {
    LoginView()
}
