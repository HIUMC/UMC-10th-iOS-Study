import SwiftUI
import KakaoSDKUser

struct ProfileView: View {
    // 💡 이름은 민감 정보가 아니니 AppStorage에 둬도 괜찮습니다.
    @AppStorage("savedName") private var savedName: String = "사용자"
    
    // 💡 아이디는 금고에서 꺼내올 것이므로 State로 선언합니다.
    @State private var savedId: String = ""
    
    private let service = LoginViewModel.keychainService
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    clubMembership
                    stateInfo
                    reserveInfo
                    
                    // 로그아웃 버튼 (테스트용으로 추가하면 좋습니다)
                    logoutButton
                }
                .padding()
            }
        }
        .onAppear {
            // ✅ 화면이 나타날 때 금고에서 아이디를 꺼내옵니다.
            if let id = KeychainService.shared.load(account: "savedId", service: service) {
                self.savedId = id
            }
        }
    }
    
    // --- 하위 뷰 정의 ---
    
    private var profileHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Text("\(savedName)님")
                        .font(.megaboxExtraBold24)
                    
                    Text("WELCOME")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.welcomeButton, in: RoundedRectangle(cornerRadius: 5))
                }
                
                HStack {
                    Text("멤버십 포인트")
                        .font(.subheadline)
                    Text("0")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.megaPurple)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: EditProfileView()) {
                Text("회원정보")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
        }
    }
    
    // 로그아웃 버튼 예시 (선택사항)
    private var logoutButton: some View {
        Button("로그아웃") {
            UserApi.shared.logout { error in
                if let error {
                    print("카카오 로그아웃 실패: \(error.localizedDescription)")
                }
            }
            KeychainService.shared.delete(account: "kakaoAccessToken", service: service)
            KeychainService.shared.delete(account: "savedId", service: service)
            KeychainService.shared.delete(account: "savedPw", service: service)
            savedName = "사용자"
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
        .padding().foregroundColor(.red)
    }

    // ... (clubMembership, stateInfo, reserveInfo 등 나머지 코드는 동일)
    private var clubMembership: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(gradient: Gradient(colors:[.gradStart,.gradMiddle,.graEnd]), startPoint: .leading, endPoint: .trailing))
                .frame(height: 60)
            HStack {
                Text("클럽 멤버십").foregroundColor(.white).fontWeight(.bold)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.white)
            }.padding(.horizontal)
        }
    }
    
    private var stateInfo: some View {
        HStack {
            stateItem(title: "쿠폰", count: "0")
            Divider().frame(height: 30)
            stateItem(title: "스토어 교환권", count: "0")
            Divider().frame(height: 30)
            stateItem(title: "모바일 티켓", count: "0")
        }.padding().background(Color.gray.opacity(0.1)).cornerRadius(12)
    }
    
    private func stateItem(title: String, count: String) -> some View {
        VStack(spacing: 5) {
            Text(title).font(.caption).foregroundColor(.gray)
            Text(count).font(.headline).fontWeight(.bold)
        }.frame(maxWidth: .infinity)
    }
    
    private var reserveInfo: some View {
        HStack(spacing: 20) {
            reserveItem(imageName: "film", title: "영화별 예매")
            reserveItem(imageName: "pin", title: "극장별 예매")
            reserveItem(imageName: "sofa", title: "특별관 예매")
            reserveItem(imageName: "cinema", title: "특별관 예매")
        }
    }
    
    private func reserveItem(imageName: String, title: String) -> some View {
        VStack(spacing: 8) {
            Image(imageName).resizable().scaledToFit().frame(width: 40, height: 40)
            Text(title).font(.caption).foregroundColor(.black)
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
}
