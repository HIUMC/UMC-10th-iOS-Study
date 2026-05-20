//
//  AuthViewModel.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//

import Foundation
import SwiftUI

@Observable
class LoginViewModel {
    var loginModel = LoginModel()
    var isLoggedIn: Bool = false
    var currentUserID: String = ""
    var currentUserName: String = ""
    var loginErrorMessage: String?

    init() {
        restoreLogin()
    }

    // MARK: - 로그인
    func login() {
        loginErrorMessage = nil
        let trimmedID = loginModel.id.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = loginModel.pwd.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedID.isEmpty, !trimmedPassword.isEmpty else {
            loginErrorMessage = "아이디와 비밀번호를 입력해주세요."
            print("로그인 실패 - 아이디 또는 비밀번호가 비어 있습니다.")
            return
        }

        let credential = LoginCredential(
            id: trimmedID,
            password: trimmedPassword,
            userName: trimmedID
        )

        guard CredentialService.shared.saveCredential(credential) else {
            loginErrorMessage = "키체인 저장에 실패했습니다."
            print("로그인 실패 - 키체인 저장에 실패했습니다.")
            return
        }

        loginModel.id = trimmedID
        loginModel.pwd = trimmedPassword
        currentUserID = credential.id
        currentUserName = credential.userName
        UserDefaults.standard.set(credential.userName, forKey: AppStorageKeys.userName)
        isLoggedIn = true
        print("로그인 성공 - ID: \(credential.id)")
    }

    @MainActor
    func loginWithKakao() async {
        loginErrorMessage = nil

        do {
            let result = try await KakaoLoginService.shared.login()

            guard KakaoTokenService.shared.saveToken(result.tokenInfo) else {
                loginErrorMessage = "카카오 토큰 저장에 실패했습니다."
                return
            }

            currentUserID = result.userID
            currentUserName = result.userName
            UserDefaults.standard.set(result.userName, forKey: AppStorageKeys.userName)
            isLoggedIn = true
            print("카카오 로그인 성공 - userID: \(result.userID)")
        } catch {
            loginErrorMessage = error.localizedDescription
            print("카카오 로그인 실패: \(error.localizedDescription)")
        }
    }

    // MARK: - 로그아웃
    func logout(container: DIContainer) {
        container.resetAll()
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.userName)
        CredentialService.shared.deleteCredential()
        KakaoTokenService.shared.deleteToken()
        loginModel = LoginModel()
        currentUserID = ""
        currentUserName = ""
        isLoggedIn = false
        loginErrorMessage = nil
    }

    private func restoreLogin() {
        guard let credential = CredentialService.shared.loadCredential() else {
            return
        }

        loginModel.id = credential.id
        loginModel.pwd = credential.password
        currentUserID = credential.id
        currentUserName = credential.userName
        UserDefaults.standard.set(credential.userName, forKey: AppStorageKeys.userName)
        isLoggedIn = true
    }

    func updateUserName(_ newName: String) {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !currentUserID.isEmpty, !loginModel.pwd.isEmpty else {
            return
        }

        let credential = LoginCredential(
            id: currentUserID,
            password: loginModel.pwd,
            userName: trimmedName
        )

        guard CredentialService.shared.saveCredential(credential) else {
            print("이름 변경 실패 - 키체인 저장에 실패했습니다.")
            return
        }

        currentUserName = trimmedName
        UserDefaults.standard.set(trimmedName, forKey: AppStorageKeys.userName)
    }
}
