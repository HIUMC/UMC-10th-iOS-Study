import SwiftUI

@main
struct UMCMegaBoxApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var container = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
                    //MainTabView 전체에 DIContainer를 환경변수로 주입
                    .environment(container)
            } else {
                LoginView()
            }
        }
    }
}
