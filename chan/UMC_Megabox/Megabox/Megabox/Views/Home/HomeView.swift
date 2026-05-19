import SwiftUI

struct HomeView: View {
    // ⭐️ 상단 탭 메뉴 상태 (하단 탭바와 별개로 동작)
    @State private var selectedTopMenu = "홈"
    let topMenus = ["홈", "이벤트", "스토어", "선호극장"]
    
    var body: some View {
        // ⭐️ 전체 스크롤 뷰 (ZStack 제거로 터치 간섭 최소화)
        ScrollView {
            VStack(spacing: 0) {
                
                // 1. 로고 바로 밑 상단 메뉴바 (보라색 밑줄)
                topMenuBar
                
                // 2. 메인 콘텐츠 섹션
                VStack(spacing: 40) {
                    if selectedTopMenu == "홈" {
                        // 영화 차트 섹션 (기존 작성하신 뷰)
                        MovieCardView()
                        
                        // ⭐️ 특별관 섹션 (408x408 고정 + 터치 안 씹히는 구조)
                        SpecialTheaterView()
                            .padding(.bottom, 50)
                    } else {
                        // 홈 외 메뉴 클릭 시 준비 중 화면
                        placeholderSection
                    }
                }
                .padding(.top, 20)
            }
        }
        .scrollIndicators(.hidden)
        // ⭐️ 상단 툴바 (NavigationStack 내부에서만 보임)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                logoButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                headerIcons
            }
        }
    }
}

// MARK: - Subviews
extension HomeView {
    
    // (1) 상단 메뉴바
    private var topMenuBar: some View {
        HStack(spacing: 20) {
            ForEach(topMenus, id: \.self) { menu in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTopMenu = menu
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(menu)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(selectedTopMenu == menu ? .black : .gray)
                        
                        Rectangle()
                            .fill(selectedTopMenu == menu ? Color.purple : Color.clear)
                            .frame(width: 30, height: 3)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .background(Color.white)
    }
    
    // (2) 메가박스 로고 버튼
    private var logoButton: some View {
        Button(action: { print("로고 클릭") }) {
            Image("meboxLogo 2") // 에셋 이름 확인 필수!
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 24)
        }
        .buttonStyle(.plain)
    }
    
    // (3) 상단 우측 아이콘 세트
    private var headerIcons: some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
            Image(systemName: "bell")
        }
        .foregroundColor(.black)
    }
    
    // (4) 섹션 준비 중 화면
    private var placeholderSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "hourglass.badge.plus")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.4))
            
            Text("\(selectedTopMenu) 서비스는\n열심히 준비 중입니다.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(minHeight: 450)
    }
}

// ⭐️ 프리뷰에서 로고를 확인하려면 반드시 NavigationStack으로 감싸야 합니다!
#Preview {
    NavigationStack {
        HomeView()
    }
}
