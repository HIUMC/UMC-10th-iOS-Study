import SwiftUI

struct SpecialTheaterView: View {
    @State private var viewModel = SpecialTheaterViewModel()
    private let cardSize: CGFloat = 408
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
                .padding(.horizontal)
            
            logoSelectionBar
                .padding(.vertical, 20)
            
            // ⭐️ 뷰 교체가 아닌 '투명도 조절' 방식
            selectedTheaterImageSection
        }
        .padding(.vertical, 20)
        .background(Color.white)
    }
}

// MARK: - Subviews
extension SpecialTheaterView {
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            Text("메가박스의 모든 특별관")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            LiquidGlassButton(systemName: "chevron.right", width: 34, height: 34, cornerRadius: 17) {
                print("전체보기")
            }
        }
    }
    
    // (2) ⭐️ 터치 반응성 극대화 로고 바
    private var logoSelectionBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(viewModel.theaters) { theater in
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(viewModel.selectedTheater?.id == theater.id ? Color.white : Color(uiColor: .systemGray6))
                                .frame(width: 56, height: 56)
                                .shadow(color: .black.opacity(viewModel.selectedTheater?.id == theater.id ? 0.1 : 0), radius: 4)
                            
                            Image(theater.logoImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .grayscale(viewModel.selectedTheater?.id == theater.id ? 0 : 1.0)
                                .blendMode(viewModel.selectedTheater?.id == theater.id ? .normal : .multiply)
                                .opacity(viewModel.selectedTheater?.id == theater.id ? 1.0 : 0.6)
                        }
                        
                        Circle()
                            .fill(viewModel.selectedTheater?.id == theater.id ? Color.purple : Color.clear)
                            .frame(width: 5, height: 5)
                    }
                    .contentShape(Circle()) // 터치 영역 최적화
                    .onTapGesture {
                        // ⭐️ withAnimation을 쓰되, 뷰를 파괴하지 않는 속성만 변경
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
                            viewModel.selectedTheater = theater
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    
    // SpecialTheaterView.swift (가장 가벼운 버전)
    private var selectedTheaterImageSection: some View {
        // ⭐️ TabView는 이미지를 미리 로드하지 않고 넘길 때만 처리해서 터치가 안 씹힙니다.
        TabView(selection: $viewModel.selectedTheater) {
            ForEach(viewModel.theaters) { theater in
                ZStack(alignment: .topLeading) {
                    Image(theater.mainImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 408, height: 408)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // (그라데이션 & 텍스트는 기존과 동일)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(theater.name).font(.headline).foregroundColor(.white)
                        Text(theater.description).font(.subheadline).foregroundColor(.white.opacity(0.8))
                    }
                    .padding(25)
                }
                .tag(theater as SpecialTheater?) // ⭐️ 핵심: 선택 상태와 연동
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // 페이지 점 숨김
        .frame(width: 408, height: 408)
        .animation(.spring(), value: viewModel.selectedTheater) // ⭐️ 바뀔 때만 애니메이션
    }}
