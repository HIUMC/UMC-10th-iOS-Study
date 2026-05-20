

import SwiftUI

struct MobileOrderView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("모바일 오더")
                    .font(.pretendardBold24)
                    .foregroundColor(Color(.gray04))
                Text("여기에 모바일 오더 화면이 들어온다")
                    .font(.pretendardMedium14)
                    .foregroundColor(Color(.gray02))
                Spacer()
            }
        }
    }
}

#Preview {
    MobileOrderView()
}
