import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("홈 화면")
                    .font(.pretendardBold24)
                    .foregroundColor(Color(.gray04))
                Text("곧 여기에 메가박스 홈이 들어갑니다")
                    .font(.pretendardMedium14)
                    .foregroundColor(Color(.gray02))
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
