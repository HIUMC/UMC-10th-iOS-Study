import SwiftUI

struct MemberInfoView: View {
    @Environment(AuthViewModel.self) private var authVM
    @State private var editName: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // 회원 아이디 행
            HStack {
                Text(authVM.userID)
                    .font(.pretendardMedium14)
                    .foregroundColor(Color(.black))
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 5)
            Divider()
                .background(Color(.gray02))

            // 회원 이름 행
            HStack {
                TextField("이름을 입력하세요", text: $editName)
                    .font(.pretendardMedium14)
                    .foregroundColor(Color(.black))

                Spacer()

                Button(action: {
                    authVM.updateName(editName)
                }) {
                    Text("변경")
                        .font(.pretendardMedium10)
                        .foregroundColor(Color(.gray03))
                        .padding(.horizontal, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(.gray03), lineWidth: 1)
                                .frame(width:38, height:20)
                        )
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 5)

            Divider()
                .background(Color(.gray02))
        }
        .onAppear {
            editName = authVM.displayName
        }
    }
}
