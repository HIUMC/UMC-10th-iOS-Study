//
//  RootView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/31/26.
//

import SwiftUI

struct RootView: View {
    @State private var container = DIContainer()
    @State private var authVM = AuthViewModel()

    var body: some View {
        #if DEBUG
        if Self.isMobileOrderSnapshotMode {
            MainTabView()
                .environment(container)
                .environment(authVM)
                .task {
                    container.selectedTab = 2
                }
        } else if Self.isMobileOrderDetailSnapshotMode {
            NavigationStack {
                MobileOrderDetailView(item: MobileOrderMenuStore.featuredItem, branchName: "강남")
            }
        } else if authVM.isLoggedIn {
            MainTabView()
                .environment(container)
                .environment(authVM)
        } else {
            LoginView()
                .environment(authVM)
        }
        #else
        if authVM.isLoggedIn {
            MainTabView()
                .environment(container)
                .environment(authVM)
        } else {
            LoginView()
                .environment(authVM)
        }
        #endif
    }

    #if DEBUG
    private static var isMobileOrderSnapshotMode: Bool {
        ProcessInfo.processInfo.arguments.contains("-MobileOrderSnapshotMode")
    }

    private static var isMobileOrderDetailSnapshotMode: Bool {
        ProcessInfo.processInfo.arguments.contains("-MobileOrderDetailSnapshotMode")
    }
    #endif
}

#Preview {
    RootView()
}
