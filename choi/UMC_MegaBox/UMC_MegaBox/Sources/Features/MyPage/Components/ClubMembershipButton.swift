import SwiftUI

struct ClubMembershipButton: View {
    var body: some View {
        Button(action: {}) {
            HStack(alignment: .center, spacing: 3) {
                Text("클럽 멤버십")
                    .font(.pretendardSemiBold16)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                Image(systemName: "chevron.right")
                    .frame(width:16, height:16)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.67, green: 0.55, blue: 1), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.56, green: 0.68, blue: 0.95), location: 0.53),
                        Gradient.Stop(color: Color(red: 0.36, green: 0.8, blue: 0.93), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0, y: 0.5),
                    endPoint: UnitPoint(x: 1, y: 0.5)
                )
            )
            .cornerRadius(8)
            }
    }
}
