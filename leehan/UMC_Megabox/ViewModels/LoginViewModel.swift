//
//  LoginViewModel.swift
//  leehan
//
//  Created by 이한결 on 3/25/26.
//

import Foundation

@Observable
class LoginViewModel {
    var loginModel: LoginModel = LoginModel(id: "", pwd: "")
    
    func loginId(id: String) {
        self.loginModel.id = id
    }
    
    func loginpwd(pwd: String) {
        self.loginModel.pwd = pwd
    }
}
