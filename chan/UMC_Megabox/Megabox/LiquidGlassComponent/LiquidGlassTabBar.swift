import SwiftUI

struct LiquidGlassTabBar: View {
    // ⭐️ 부모 뷰(HomeView)의 선택 상태를 연결합니다.
    @Binding var selectedTab: String
    
    let tabs = ["홈", "이벤트", "스토어", "선호극장"]
    @Namespace private var tabAnimation // 쫀득한 이동 애니메이션용
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        // ⭐️ 탭바 전체의 유리 질감 배경
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.5), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
        }
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
    }
    
    // 개별 탭 버튼 로직
    private func tabButton(for tab: String) -> some View {
        Button(action: {
            // 탭 클릭 시 쫀득한 스프링 애니메이션 적용
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: getIcon(for: tab))
                    .font(.system(size: 20, weight: .bold))
                
                Text(tab)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(selectedTab == tab ? .white : .gray.opacity(0.7))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                if selectedTab == tab {
                    // ⭐️ 선택된 탭을 따라다니는 액체 하이라이트
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .matchedGeometryEffect(id: "activeTab", in: tabAnimation)
                }
            }
        }
    }
    
    private func getIcon(for tab: String) -> String {
        switch tab {
        case "홈": return "house.fill"
        case "이벤트": return "sparkles"
        case "스토어": return "bag.fill"
        case "선호극장": return "mappin.and.ellipse"
        default: return "circle"
        }
    }
}

#Preview {
    // 프리뷰를 위해 임시 상태값 전달
    LiquidGlassTabBar(selectedTab: .constant("홈"))
        .preferredColorScheme(.dark)
}
