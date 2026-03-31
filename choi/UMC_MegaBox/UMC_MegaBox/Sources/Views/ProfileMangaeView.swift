//
//  MemberInfo.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI

struct ProfileMangaeView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            BasicInfoText()
                .padding(.top, 50)
                .padding(.horizontal, 25)

            MemberInfo()
                .padding(.top, 10)
                .padding(.horizontal, 25)

            Spacer()
            LogoutButton()
            Spacer()
        }
        .navigationTitle("회원 정보 관리")
        .navigationBarTitleDisplayMode(.inline) // 타이틀을 가운데에 작게 표시

    }
}


struct BasicInfoText: View {
    var body: some View {
        HStack {
            Text("기본정보")
                .font(.pretendardBold18)
                .foregroundColor(Color(.black))
            Spacer()
        }
    }
}


struct MemberInfo: View {
    @AppStorage("id") private var id: String = ""
    @AppStorage("name") private var name: String = ""
    @State private var editName: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // 회원 아이디 행
            HStack {
                Text(id)
                    .font(.pretendardMedium14)
                    .foregroundColor(Color(.black))
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 5)
            Divider()
                .background(Color(.gray02))

            // 회원 이름 행
            HStack {
                TextField("이름을 입력하세요", text: $editName)
                    .font(.pretendardMedium14)
                    .foregroundColor(Color(.black))

                Spacer()

                Button(action: {
                    name = editName
                }) {
                    Text("변경")
                        .font(.pretendardMedium10)
                        .foregroundColor(Color(.gray03))
                        .padding(.horizontal, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(.gray03), lineWidth: 1)
                                .frame(width:38, height:20)
                        )
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 5)

            Divider()
                .background(Color(.gray02))
        }
        .onAppear {
            editName = name
        }
    }
}
struct LogoutButton: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        Button(action: {
                        isLoggedIn = false // 값을 false로 바꾸면 앱이 즉시 로그인 화면으로 튕겨냅니다!
                    }) {
                        Text("로그아웃")
                            .font(.pretendardSemiBold14)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.gray04))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
    }
}



#Preview {
    ProfileMangaeView()
}
