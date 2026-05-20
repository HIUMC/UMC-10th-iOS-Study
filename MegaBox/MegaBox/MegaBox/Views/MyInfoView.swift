//
//  MyInfoView.swift
//  MegaBox
//
//  Created by 김민지 on 4/1/26.
//

import SwiftUI

struct MyInfoView: View {
    @Environment(LoginViewModel.self) private var authVM
    @AppStorage(AppStorageKeys.userName) private var userName: String = ""
    @Environment(\.dismiss) private var dismiss
    
    // TextField에서 입력을 받기 위한 임시 상태 변수 (변경 버튼 클릭 시 AppStorage에 저장)
    @State private var newName: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            navigationBar
            
            infoTitle
            
            MyInfoSection
            
            Spacer()
        }
        .padding()
        .onAppear {
            // 초기 진입 시 현재 저장된 이름을 입력창에 넣어줌
            newName = authVM.currentUserName.isEmpty ? userName : authVM.currentUserName
        }
    }
    
    // 네비게이션 바
    private var navigationBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 26, height: 22)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("회원정보 관리")
                .pretendStyle(.medium16)
            
            Spacer()
            
            // 좌우 균형을 위한 빈 공간 (타이틀 중앙 배치를 위함)
            Color.clear.frame(width: 27, height: 30)
        }
    }
    
    // 기본 정보
    private var infoTitle: some View {
        Text("기본정보")
            .pretendStyle(.bold18)
    }
    
    // 회원 아이디 및 이름 뷰
    private var MyInfoSection: some View {
        VStack(spacing: 5) {
            HStack {
                Text("회원 아이디")
                    .pretendStyle(.medium18)
                    .frame(width: 100, alignment: .leading)
                
                Text(authVM.currentUserID.isEmpty ? "아이디 없음" : authVM.currentUserID)
                    .pretendStyle(.medium16)
                    .foregroundColor(.gray02)
                
                Spacer()
            }
            
            Divider()
                .padding(.bottom, 15)
            
            // 회원 이름 (변경 가능 TextField)
            HStack {
                Text("회원 이름")
                    .pretendStyle(.medium18)
                    .frame(width: 100, alignment: .leading)
                
                // 사용자가 변경할 수 있게 TextField로 구현
                TextField("이름을 입력하세요", text: $newName)
                    .pretendStyle(.medium16)
                    .foregroundColor(.gray02)
                
                Spacer()
                
                Button(action: {
                    authVM.updateUserName(newName)
                    userName = authVM.currentUserName
                    print("이름 변경 완료: \(authVM.currentUserName)")
                }) {
                    Text("변경")
                        .pretendStyle(.medium16)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray03, lineWidth: 1)
                        )
                        .foregroundColor(.black)
                }
            }
            
            Divider()
        }
    }
}

#Preview {
    MyInfoView()
        .environment(LoginViewModel())
}
