import SwiftUI


struct MainRootView: View{
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = false
    
    var body : some View{
        // 여기는 로고는 안보고, 오직 로그인 여부만 본다.
        if isLoggedIn{
            MainTabView()
        }else {
            LoginView()
        }
    }
}

