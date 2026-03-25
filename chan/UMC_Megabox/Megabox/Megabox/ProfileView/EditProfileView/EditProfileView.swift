import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("savedId") private var savedId: String = ""
    @AppStorage("savedName") private var savedName: String = "사용자"
    
    @State private var inputName: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // 💡 1. 하위 뷰들을 여기서 조립합니다!
            navigationBar
            
            VStack(alignment: .leading, spacing: 0) {
                infoTitleSection
                userNameEditSection // 이름 수정 섹션 (ID 섹션 포함)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            inputName = savedName
        }
        .navigationBarBackButtonHidden(true)
    } // <- 여기서 EditProfileView의 body가 끝남
    
    // --- 💡 여기서부터 하위 뷰들을 struct "안에" 정의합니다 ---

    private var navigationBar : some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }
            Spacer()
            Text("회원정보 관리")
                .font(.megaboxMedium16)
            Spacer()
            Image(systemName: "arrow.left").opacity(0)
        }
        .padding()
    }

    private var infoTitleSection : some View {
        Text("기본 정보")
            .font(.megaboxMedium16)
            .foregroundColor(.megaGraygray03)
            .padding(.top, 20)
            .padding(.bottom, 15)
    }

    private var userNameEditSection : some View {
        VStack(alignment: .leading, spacing: 15) {
            // 회원 아이디 (텍스트 고정)
            VStack(alignment: .leading, spacing: 8) {
                Text(savedId)
                    .font(.body)
                    .font(.megaBoxMedium18)
            }
            
            Divider()
            
            // 회원 이름 (수정 가능)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TextField("이름을 입력하세요", text: $inputName)
                        .font(.body)
                        .font(.megaBoxMedium18)
                    
                    Button(action: {
                        savedName = inputName
                        print("이름 \(savedName) 저장!")
                    }) {
                        Text("변경")
                            .font(.megaBoxMedium10)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.black) // 1. 글자색 검은색
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white) // 2. 배경색 흰색
                            .cornerRadius(5) // 3. 모서리 깎기
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.megaGraygray03, lineWidth: 1) // 4. 테두리(Stroke) 입히기
                            )
                    }
                }
            }
            
            Divider()
        }
    }
} // <- EditProfileView 구조체의 진짜 끝!

#Preview {
    EditProfileView()
}
