import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image(.meboxLogo1)
                .frame(width: 249, height: 84)
        }
        .padding()
    }
    
   
    }

#Preview {
    SplashView()
}
