//
//  LoginView.swift
//  leehan
//
//  Created by 이한결 on 3/18/26.
//

import SwiftUI

struct LoginView: View {
    @State private var id = ""
    @State private var pw = ""
    
    var body: some View {
        VStack {
            Text("로그인")
                .font(.PretendardSemiBold(size: 24))
                .foregroundStyle(.black)
            
            Spacer()
            
            TextField("아이디", text: $id)
            Divider().padding(.bottom, 40)
            TextField("비밀번호", text: $pw)
            Divider()
            
            Spacer().frame(height: 65)
            
            Button( action: {} ) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.purple03)
                        
                    Text("로그인")
                        .foregroundStyle(.white)
                        .font(.PretendardBold(size: 18))
                }
            }.frame(height: 54)
            
            Spacer().frame(height: 7)
            
            Button( action: {} ) {
                Text("회원가입")
                    .foregroundStyle(.gray04)
                    .font(.PretendardMedium(size: 13))
            }
            
            Spacer().frame(height: 25)
            
            HStack {
                Spacer()
                Button( action: {} ) {
                    Image("icon_naver")
                }
                Spacer()
                Button( action: {} ) {
                    Image("icon_kakao")
                }
                Spacer()
                Button( action: {} ) {
                    Image("icon_apple")
                }
                Spacer()
            }
            
            Spacer().frame(height: 29)
            
            Image("banner_umc10th")
                .resizable()
                .scaledToFit()
                
            
            Spacer().frame(height: 210)
        }.padding(.horizontal)
    }
}

#Preview {
    LoginView()
}
