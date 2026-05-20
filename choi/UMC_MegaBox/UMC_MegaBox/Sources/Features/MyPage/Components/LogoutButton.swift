import SwiftUI

struct LogoutButton: View {
    @Environment(DIContainer.self) private var container
    @Environment(AuthViewModel.self) private var authVM

    var body: some View {
        Button(action: {
                        authVM.logout(container: container)
                    }) {
                        Text("로그아웃")
                            .font(.pretendardSemiBold14)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.gray04))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
    }
}
