//
//  ProfileView.swift
//  leehan
//
//  Created by 이한결 on 3/25/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 60)
            HStack {
                ProfileHeader()
                
                Spacer()
                
                VStack {
                    Button( action: { /* 회원 정보 View로 넘어감 */ } ) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.gray07)
                            .overlay(
                                Text("회원가입")
                                    .foregroundStyle(.white)
                                    .font(.PretendardSemiBold(size: 14))
                            ).frame(width: 72)
                    }
                    
                    Spacer()
                }
            }.padding(.bottom)
                .frame(height: 50)
            
            Button( action: { /* 클럽멤버십 이동(?) */ } ) {
                ClubMemberShip()
            }.padding(.bottom, 30)
            
            HStack {
                Button( action: { } ) {
                    VStack {
                        Image("icon_movie")
                            .padding(.bottom, 10)
                        Text("영화별예매")
                            .font(.PretendardMedium(size: 16))
                            .foregroundStyle(Color.black)
                    }
                }
                Spacer()
                Button( action: { } ) {
                    VStack {
                        Image("icon_theater")
                            .padding(.bottom, 10)
                        Text("극장별예매")
                            .font(.PretendardMedium(size: 16))
                            .foregroundStyle(Color.black)
                    }
                }
                Spacer()
                Button( action: { } ) {
                    VStack {
                        Image("icon_special")
                            .padding(.bottom, 10)
                        Text("특별관예매")
                            .font(.PretendardMedium(size: 16))
                            .foregroundStyle(Color.black)
                    }
                }
                Spacer()
                Button( action: { } ) {
                    VStack {
                        Image("icon_mobile_order")
                            .padding(.bottom, 10)
                        Text("모바일오더")
                            .font(.PretendardMedium(size: 16))
                            .foregroundStyle(Color.black)
                    }
                }
            }
            
            Spacer()
        }.padding(.horizontal)
        
        
    }
}

#Preview {
    ProfileView()
}
