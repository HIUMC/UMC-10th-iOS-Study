import SwiftUI

@main
struct UMCMegaBoxApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    //@State private var container = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
