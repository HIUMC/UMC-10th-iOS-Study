import Foundation
import SwiftUI


@Observable
class LoginViewModel {
    // 1. 로그인 모델을 하나 생성합니다.
    var loginData = LoginModel()
    
    init(loginData: LoginModel = LoginModel()) {
        self.loginData = loginData
    }
    // 2. 로그인 버튼 눌렀을 때 실행될 함수
    func login() {
        print("로그인 시도 - ID: \(loginData.id), PW: \(loginData.pw)")
        
        
        if loginData.id == "admin" && loginData.pw == "1234" {
            print("로그인 성공!")
        } else {
            print("로그인 실패ㅠ")
        }
    }
}
