import SwiftUI

struct ProfileView: View {
    // 1. 🌟 @AppStorage는 반드시 Struct 바로 아래에!
    @AppStorage("savedId") private var savedId: String = ""
    @AppStorage("savedName") private var savedName: String = "사용자" // EditProfile에서 수정한 이름
    
    var body: some View {
        NavigationStack{
            ScrollView { // 내용이 많아질 것에 대비해 ScrollView 추천
                VStack(spacing: 20) {
                    profileHeader
                    clubMembership
                    stateInfo
                    reserveInfo
                }
                .padding()
            }
        }
    }
    
    // --- 하위 뷰 정의 ---
    
    // 1. 프로필 헤더 (이름 불러오기 + 회원정보 버튼)
    private var profileHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    // EditProfile에서 바꾼 이름이 실시간으로 반영됩니다!
                    Text("\(savedName)님")
                        .font(.megaboxExtraBold24)
                    
                    Text("WELCOME")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.welcomeButton,
                                    in : RoundedRectangle(cornerRadius: 5)
                        ) // WELCOME 배지
                }
                
                HStack {
                    Text("멤버십 포인트")
                        .font(.subheadline)
                    Text("0") // 포인트 값
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.megaPurple)
                }
            }
            
            Spacer()
            
            // 회원정보 버튼 (NavigationLink로 나중에 연결 가능)
            NavigationLink(destination: EditProfileView()){
                Text("회원정보")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius:20)
                            .stroke(Color.gray.opacity(0.5), lineWidth:1)
                    )
            }
        }
    }
    
    // 2. 클럽 멤버십 (LinearGradient 적용)
    private var clubMembership: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors:[.gradStart,.gradMiddle,.graEnd]), // 피그마 색상으로 변경하세요!
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(height: 60)
            
            HStack {
                Text("클럽 멤버십")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
    }
    
    // 3. 상태 정보 (쿠폰, 스토어 등)
    private var stateInfo: some View {
        HStack {
            stateItem(title: "쿠폰", count: "0")
            Divider().frame(height: 30)
            stateItem(title: "스토어 교환권", count: "0")
            Divider().frame(height: 30)
            stateItem(title: "모바일 티켓", count: "0")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    // 상태 정보용 작은 하위 뷰 함수
    private func stateItem(title: String, count: String) -> some View {
        VStack(spacing: 5) {
            Text(title).font(.caption).foregroundColor(.gray)
            Text(count).font(.headline).fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
    
    // 4. 예매 정보 (VStack + HStack 조립)
    private var reserveInfo: some View {
        HStack(spacing: 20) {
            reserveItem(imageName: "film", title: "영화별 예매")
            reserveItem(imageName: "pin", title: "극장별 예매") // 이것도 이미지 이름으로!
            reserveItem(imageName: "sofa", title: "특별관 예매")
            reserveItem(imageName: "cinema", title: "특별관 예매")
        }
    }
    
    private func reserveItem(imageName: String, title: String) -> some View {
        VStack(spacing: 8) {
            // 💡 systemName을 빼고 이미지 이름만 넣습니다.
            Image(imageName)
                .resizable()
                .scaledToFit() // 가로세로 비율 유지!
                .frame(width: 40, height: 40) // 피그마 크기에 맞춰 조절
            
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview{
    ProfileView()
}
