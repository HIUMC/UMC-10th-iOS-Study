import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("savedName") private var savedName: String = "사용자"
    
    // 💡 아이디는 금고에서 가져올 것이므로 State로 변경
    @State private var savedId: String = ""
    @State private var inputName: String = ""
    
    private let service = "com.chanhyeok.megabox"

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            VStack(alignment: .leading, spacing: 0) {
                infoTitleSection
                userNameEditSection
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            inputName = savedName
            // ✅ 화면 로드 시 금고에서 실제 저장된 아이디를 불러옴
            if let id = KeychainService.shared.load(account: "savedId", service: service) {
                self.savedId = id
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var navigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left").foregroundColor(.black)
            }
            Spacer()
            Text("회원정보 관리").font(.megaboxMedium16)
            Spacer()
            Image(systemName: "arrow.left").opacity(0)
        }.padding()
    }

    private var infoTitleSection: some View {
        Text("기본 정보")
            .font(.megaboxMedium16)
            .foregroundColor(.megaGraygray03)
            .padding(.top, 20)
            .padding(.bottom, 15)
    }

    private var userNameEditSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 회원 아이디 (금고에서 가져온 값 표시)
            VStack(alignment: .leading, spacing: 8) {
                Text(savedId.isEmpty ? "아이디 정보 없음" : savedId)
                    .font(.megaBoxMedium18)
            }
            
            Divider()
            
            // 회원 이름 (수정 가능)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TextField("이름을 입력하세요", text: $inputName)
                        .font(.megaBoxMedium18)
                    
                    Button(action: {
                        savedName = inputName
                    }) {
                        Text("변경")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.megaGraygray03, lineWidth: 1)
                            )
                    }
                }
            }
            Divider()
        }
    }
}
#Preview {
    EditProfileView()
}
