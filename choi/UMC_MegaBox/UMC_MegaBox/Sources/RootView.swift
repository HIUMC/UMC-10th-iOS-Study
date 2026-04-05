//
//  RootView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/31/26.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var container = DIContainer()
    @State private var authVM = AuthViewModel()

    var body: some View {
        if isLoggedIn {
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
    RootView()
}
