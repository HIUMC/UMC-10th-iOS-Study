//
//  LoginView.swift
//  MegaBox
//
//  Created by 김민지 on 3/31/26.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    // Observation 프레임워크의 뷰모델 생성
    @State private var viewModel = LoginViewModel()
        
    // @AppStorage를 사용하여 기기에 데이터 저장
    @AppStorage("savedId") private var savedId: String = ""
    @AppStorage("savedPwd") private var savedPwd: String = ""
    
    
    var body: some View {
        VStack {
            
            Title
            
            Info
            
            LoginButton
            
            Join
            
            SocialLogin

            UMC
        }
        .ignoresSafeArea()
        Spacer()
    }
    
    // 타이틀
    var Title: some View {
        HStack {
            Text("로그인")
                .pretendStyle(.semiBold24)
                .padding(.top, 70)
                .padding(.bottom, 100)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    // 로그인 정보 입력
    var Info: some View {
        VStack(alignment: .leading) {
            TextField("아이디", text: $viewModel.id)
                .pretendStyle(.regular13)
                .foregroundColor(Color.gray03)
            Divider()   // 밑줄
                .padding(.bottom, 30)
            
            SecureField("비밀번호", text: $viewModel.pwd)   //SecureField 사용하면 입력하는 글자가 가려져서 보이게 됨
                .pretendStyle(.regular13)
                .foregroundColor(Color.gray03)
            Divider()
                .padding(.bottom, 60)
        }
        .padding(.horizontal)
    }
    
    // 로그인 버튼
    var LoginButton: some View {
        Button(action: {
            savedId = viewModel.id
            savedPwd = viewModel.pwd
            print("저장 완료: \(savedId)")
        }) {
            Text("로그인")
                .pretendStyle(.semiBold18)
                .foregroundColor(.white)
                .frame(width: 380, height: 54)
                .background(Color.purple03) // 배경색(purple03)
                .cornerRadius(36) // 둥근 모서리
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    // 회원 가입
    var Join: some View {
        Text("회원가입")
            .pretendStyle(.medium13)
            .foregroundColor(.gray04)
    }
    
    // 5. 소셜 로그인 (가로 정렬)
    var SocialLogin: some View {
        HStack(spacing: 50) {
            Image("Naver")
            Image("Kakao")
            Image("Apple")
            
        }
        .padding(.vertical)
    }
    // umc 배너
    var UMC: some View {
        Image(.umc)
            .resizable()    // 이미지 크기를 유연하게 바꿀 수 있도록 함
            .scaledToFit()   // 이미지 비율을 유지
            .frame(width: 380, height: 103)
            .padding(.horizontal)
    }
}

#Preview {
    LoginView()
}
