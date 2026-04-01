//
//  LoginViewModel.swift
//  MegaBox
//
//  Created by 김민지 on 4/1/26.
//

import Foundation
import Observation

@Observable
class LoginViewModel {
    // LoginModel 초기화
    var loginData = LoginModel()
    
    // 텍스트필드와 바인딩될 수 있도록 id와 pwd를 직접 제공하거나 모델을 통해 관리
    var id: String {
        get { loginData.id }
        set { loginData.id = newValue }
    }
    
    var pwd: String {
        get { loginData.pwd }
        set { loginData.pwd = newValue }
    }
}
