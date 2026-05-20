//
//  MemberInfo.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI

struct ProfileManageView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            BasicInfoText()
                .padding(.top, 50)
                .padding(.horizontal, 25)

            MemberInfoView()
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

#Preview {
    NavigationStack {
        ProfileManageView()
    }
    .environment(DIContainer())
    .environment(AuthViewModel())
}
