//
//  AuthViewModel.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import Foundation

@Observable
class AuthViewModel {
    var loginModel = LoginModel()

    // computed property: @AppStorage는 View 전용이므로, ViewModel에서는 UserDefaults 직접 사용
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: "isLoggedIn") }
        set { UserDefaults.standard.set(newValue, forKey: "isLoggedIn") }
    }

    // MARK: - 로그인
    func login() {
        UserDefaults.standard.set(loginModel.id, forKey: "id")
        UserDefaults.standard.set(loginModel.pwd, forKey: "pwd")
        isLoggedIn = true
        print("로그인 시도 - ID: \(loginModel.id), PW: \(loginModel.pwd)")
    }

    // MARK: - 로그아웃
    func logout(container: DIContainerProtocol) {
        container.resetAll()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
