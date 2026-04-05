//
//  SplashView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/18/26.
//

import SwiftUI

public struct SplashView: View {
    public var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            Image("meboxLogo 1")
                .resizable() // 이미지 크기를 조절할 수 있도록 만듬.
                .aspectRatio(contentMode: .fit) // 이미지의 원래 비율을 훼손하지 않음.
                .frame(width: 249, height: 84) //고정 크기 fixed로.
        }
    }
    
}


#Preview {
    SplashView()
}
