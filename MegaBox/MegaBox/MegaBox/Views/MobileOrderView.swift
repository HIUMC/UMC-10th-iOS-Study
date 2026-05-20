//
//  MobileOrderView.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//



import SwiftUI

struct MobileOrderView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("모바일 오더")
                    .foregroundColor(Color(.gray04))
                Text("여기에 모바일 오더 화면이 들어온다")
                    .foregroundColor(Color(.gray02))
                Spacer()
            }
        }
    }
}

#Preview {
    MobileOrderView()
}
