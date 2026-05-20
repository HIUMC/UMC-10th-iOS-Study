//
//  Root.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//

import SwiftUI

struct Root: View {
    @State private var container = DIContainer()
    @State private var authVM = LoginViewModel()

    var body: some View {
        if authVM.isLoggedIn {
            MainTabView()
                .environment(container)
                .environment(authVM)
        } else {
            LoginView()
                .environment(authVM)
        }
    }
}

#Preview {
    Root()
}
