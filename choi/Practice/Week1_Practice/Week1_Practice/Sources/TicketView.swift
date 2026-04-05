//
//  Untitled.swift
//  Week1_Practice
//
//  Created by 최민혁 on 3/16/26.
//

import SwiftUI

struct TicketView: View {
    var body: some View {
        ZStack(alignment: .bottom){
            Image(.background)
                .resizable()
                .frame(width: 385, height: 386)
                .overlay(Color.black.opacity(0.3))
                .shadow(
                    color: .black.opacity(0.25),
                    radius: 2, // 💡 피그마 Blur(4) - 2 = 2
                    x: 0,
                    y: 4
                )
            VStack{
                mainTitleGroup
                Spacer().frame(height: 138)
                mainBottomGroup
                    .padding(.bottom, 13)
            }
        }
        .padding()
    }
    private var mainTitleGroup: some View{
        VStack{
            VStack{
                Group{
                    Text("마이펫의 이중생활2")
                    .font(.PretendardBold30)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    Text("본인 + 동반 1인")
                    .font(.PretendardLight16)
                    Text("30,100원")
                    .font(.PretendardBold24)
                    }
                .foregroundColor(Color.white)
                }
            .frame(height: 84)
        }
        
    }
}

private var mainBottomGroup: some View{
    Button(action:{
        print("Hello")
    },label:{
        VStack{
            Image(systemName: "chevron.up")
                .resizable()
                .frame(width: 18, height: 12)
                .foregroundStyle(Color.gray)
            Text("예매하기")
                .font(.PretendardSemiBold18)
                .foregroundStyle(Color.gray)

        }
        .frame(width: 63, height: 40)

    })
}

#Preview {
    TicketView()
}
