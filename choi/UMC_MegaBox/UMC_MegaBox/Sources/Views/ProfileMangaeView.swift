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
            NavigationBar()
                .padding(.top, 20)
                .padding(.horizontal, 25)

            BasicInfoText()
                .padding(.top, 50)
                .padding(.horizontal, 25)

            MemberInfo()
                .padding(.top, 10)
                .padding(.horizontal, 25)

            Spacer()
        }
    }
}


struct NavigationBar: View {

    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.black))
            }

            Spacer()

            Text("회원정보 관리")
                .font(.pretendardMedium16)
                .foregroundColor(Color(.black))

            Spacer()

            // 좌우 균형을 위한 투명 요소
            Image(systemName: "arrow.left")
                .font(.system(size: 20))
                .opacity(0)
        }
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



#Preview {
    ProfileMangaeView()
}
