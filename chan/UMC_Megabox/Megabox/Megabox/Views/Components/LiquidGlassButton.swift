import SwiftUI

struct LiquidGlassButton: View {
    var title: String? = nil
    var systemName: String? = nil
    var width: CGFloat? = nil
    var height: CGFloat = 60
    var cornerRadius: CGFloat = 20
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if let systemName = systemName {
                    Image(systemName: systemName)
                } else if let title = title {
                    Text(title)
                }
            }
            .font(.system(size: height * 0.4, weight: .bold))
            // ⭐️ 아이콘/텍스트 색상을 검은색 계열로 해서 가독성 확보
            .foregroundColor(.black.opacity(0.7))
            .frame(width: width)
            .frame(maxWidth: width == nil ? .infinity : nil)
            .frame(height: height)
            .background {
                // ⭐️ 배경색을 화이트/실버 톤으로 변경
                MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ], colors: [
                    .white.opacity(0.8), .white.opacity(0.4), .gray.opacity(0.1),
                    .gray.opacity(0.1), .white.opacity(0.9), .white.opacity(0.5),
                    .white.opacity(0.6), .gray.opacity(0.2), .white.opacity(0.8)
                ])
                .blur(radius: 5)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                // ⭐️ 테두리 하이라이트를 더 가늘고 밝게 (유리 광택)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            // ⭐️ 배경 굴절 효과 (배경이 흰색이어도 미세하게 비치도록)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            // ⭐️ 그림자를 아주 연하게 (둥둥 떠 있는 느낌만)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        // 컴포넌트 내부 padding은 제거했습니다! 필요하면 호출하는 곳에서 넣으세요.
    }
}
