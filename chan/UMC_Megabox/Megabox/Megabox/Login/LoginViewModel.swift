import SwiftUI

@Observable
class LoginViewModel {
    var loginData = LoginModel()
    
    // 키체인에 저장된 아이디가 있는지 확인해서 있으면 로그인 상태로 넘겨주기 위한 변수
    var isLoggedIn: Bool = false
    
    private let service = "com.chanhyeok.megabox" // 서비스 이름 통일

    init() {
        checkAutoLogin()
    }
    
    // 자동 로그인 체크 (앱 켜질 때 실행)
    /// 만약에 값이 둘 다 있으면 self.isLoggenIn = true
    ///
    func checkAutoLogin() {
        if let _ = KeychainService.shared.load(account: "savedId", service: service),
           let _ = KeychainService.shared.load(account: "savedPw", service: service) {
            self.isLoggedIn = true
        }
    }
    
    // 로그인 함수
    func login() {
        // 실제 프로젝트라면 여기서 Alamofire로 서버 통신을 하겠죠?
        // 지금은 입력값이 비어있지 않으면 성공하는 걸로 처리합니다.
        if !loginData.id.isEmpty && !loginData.pw.isEmpty {
            // 1. 금고(Keychain)에 안전하게 저장
            KeychainService.shared.save(account: "savedId", service: service, value: loginData.id)
            KeychainService.shared.save(account: "savedPw", service: service, value: loginData.pw)
            
            print("금고 저장 완료 - ID: \(loginData.id)")
            self.isLoggedIn = true
        } else {
            print("아이디와 비밀번호를 입력해주세요.")
        }
    }
    
    // 로그아웃 시 금고 비우기
    func logout() {
        KeychainService.shared.delete(account: "savedId", service: service)
        KeychainService.shared.delete(account: "savedPw", service: service)
        self.isLoggedIn = false
    }
}
