import Foundation
import SwiftUI
import KakaoSDKUser
import KakaoSDKAuth
import AuthenticationServices

@MainActor
@Observable
final class LoginViewModel {
    var loginData = LoginModel()
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?

    static let keychainService = "chan.Megabox"
    private let service = LoginViewModel.keychainService

    init() {
        checkAutoLogin()
    }

    // MARK: - 일반 로그인
    func login() {
        isLoading = true
        
        guard !loginData.id.isEmpty, !loginData.pw.isEmpty else {
            errorMessage = "아이디와 비밀번호를 모두 입력해주세요."
            isLoading = false
            return
        }
        
        KeychainService.shared.save(account: "savedId", service: service, value: loginData.id)
        isLoading = false
        isLoggedIn = true
    }

    // MARK: - 카카오 로그인
    func handleKakaoLogin() {
        print("1. 카카오 로그인 시도")
        isLoading = true
        errorMessage = nil
        
        // [안전장치] 만약 리다이렉트 문제로 응답이 안 오면 10초 후 로딩 강제 종료
        Task {
            try? await Task.sleep(nanoseconds: 10 * 1_000_000_000)
            if self.isLoading {
                print("⚠️ 응답 시간 초과: 로딩을 강제로 종료합니다.")
                self.isLoading = false
            }
        }
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                // SDK의 클로저는 백그라운드 스레드일 수 있으므로 MainActor에서 처리
                Task { @MainActor in
                    self?.processResult(oauthToken: oauthToken, error: error)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                Task { @MainActor in
                    self?.processResult(oauthToken: oauthToken, error: error)
                }
            }
        }
    }

    private func processResult(oauthToken: OAuthToken?, error: Error?) {
        print("2. 카카오 응답 처리 시작")
        self.isLoading = false
        
        if let error = error {
            let sdkError = error as NSError
            // 사용자가 취소한 경우는 에러 메시지를 띄우지 않음
            if sdkError.domain == ASWebAuthenticationSessionErrorDomain && sdkError.code == 1 {
                print("🚫 사용자가 인증을 취소함")
            } else {
                print("❌ 로그인 에러: \(error.localizedDescription)")
                self.errorMessage = "카카오 로그인 실패: \(error.localizedDescription)"
            }
        } else if let token = oauthToken {
            print("✅ 로그인 성공")
            KeychainService.shared.save(account: "kakaoAccessToken", service: service, value: token.accessToken)
            fetchKakaoUserProfile()
        }
    }

    private func fetchKakaoUserProfile() {
        UserApi.shared.me { [weak self] user, error in
            Task { @MainActor in
                guard let self else { return }

                if let error {
                    print("⚠️ 카카오 사용자 정보 요청 실패: \(error.localizedDescription)")
                    UserDefaults.standard.set("카카오 사용자", forKey: "savedName")
                } else {
                    let nickname = user?.kakaoAccount?.profile?.nickname ?? "카카오 사용자"
                    UserDefaults.standard.set(nickname, forKey: "savedName")
                    if let id = user?.id {
                        KeychainService.shared.save(account: "savedId", service: self.service, value: "\(id)")
                    }
                }

                self.isLoggedIn = true
            }
        }
    }

    // MARK: - 자동 로그인 및 로그아웃
    func checkAutoLogin() {
        if KeychainService.shared.load(account: "kakaoAccessToken", service: service) != nil ||
           KeychainService.shared.load(account: "savedId", service: service) != nil {
            isLoggedIn = true
        }
    }

    func logout() {
        UserApi.shared.logout { _ in }
        KeychainService.shared.delete(account: "kakaoAccessToken", service: service)
        KeychainService.shared.delete(account: "savedId", service: service)
        isLoggedIn = false
    }
}
