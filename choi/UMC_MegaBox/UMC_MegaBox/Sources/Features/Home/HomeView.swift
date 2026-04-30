import SwiftUI

struct HomeView: View {
    @Environment(NavigationRouter<HomeRoute>.self) private var router
    @Environment(DIContainer.self) private var container
    @State private var viewModel = HomeViewModel()

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.path) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // 무비차트 / 상영예정 토글
                    movieChartToggle
                        .padding(.top, 16)
                        .padding(.horizontal, 20)

                    // 무비카드 가로 스크롤
                    movieCardScroll
                        .padding(.top, 16)

                    // 메가박스의 모든 특별관
                    specialTheaterSection
                        .padding(.top, 30)

                    // 특별관 카드 (PageControl)
                    specialTheaterCard
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("meboxLogo 2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 149, height: 30)
                }
                .sharedBackgroundVisibility(.hidden)

            }
            .safeAreaBar(edge: .top) {
                headerSegment
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .movieDetail(let movie):
                    MovieDetailView(movie: movie)
                }
            }
        }
    }

    // MARK: - 상단 세그먼트

    private var headerSegment: some View {
        HStack(spacing: 20) {
            ForEach(["홈", "이벤트", "스토어", "선호극장"], id: \.self) { tab in
                Button(action: {}) {
                    Text(tab)
                        .font(.pretendardSemiBold24)
                        .foregroundStyle(tab == "홈" ? Color(.black) : Color(.gray03))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    // MARK: - 무비차트 / 상영예정 토글

    private var movieChartToggle: some View {
        HStack(spacing: 12) {
            chartToggleButton(title: "무비차트", type: .nowPlaying)
            chartToggleButton(title: "상영예정", type: .upcoming)
            Spacer()
        }
    }

    // 토글 버튼 헬퍼 — 중복 코드 제거
    private func chartToggleButton(title: String, type: HomeViewModel.MovieChartType) -> some View {
        Button(action: { viewModel.selectedSegment = type }) {
            Text(title)
                .font(.pretendardSemiBold14)
                .foregroundStyle(viewModel.selectedSegment == type ? .white : Color(.gray04))
            
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(viewModel.selectedSegment == type ? Color(.gray08) : Color(.gray02))
                .cornerRadius(16)
            
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(viewModel.selectedSegment == type ? Color.clear : Color(.gray02), lineWidth: 1)
                )
        }
    }

    // MARK: - 무비카드 가로 스크롤

    private var movieCardScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.currentMovies(for: viewModel.selectedSegment)) { movie in
                    MovieCardView(movie: movie) {
                        container.selectedTab = 1
                    }
                    .onTapGesture {
                        router.push(.movieDetail(movie))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - 메가박스의 모든 특별관

    private var specialTheaterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("메가박스의 모든 특별관")
                    .font(.pretendardBold24)
                    .foregroundStyle(Color(.black))
                Spacer()
                Button(action: {
                    let next = min(viewModel.selectedTheaterIndex + 1, viewModel.theaters.count - 1)
                    withAnimation {
                        viewModel.selectedTheaterIndex = next
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color(.gray07))
                }
                .buttonStyle(.glass)
            }
            .padding(.horizontal, 20)

            // 특별관 로고 가로 스크롤
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(Array(viewModel.theaters.enumerated()), id: \.offset) { index, theater in
                            VStack(spacing: 4) {
                                let isSelected = (viewModel.selectedTheaterIndex == index)

                                Image(theater.logo)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding(10)
                                    .background {
                                        if isSelected {
                                            Circle()
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 4, y: 4)
                                                .shadow(color: Color.white.opacity(0.9), radius: 6, x: -4, y: -4)
                                        } else {
                                            Circle()
                                                .fill(
                                                    Color(.gray02)
                                                        .shadow(.inner(color: Color.black.opacity(0.2), radius: 5, x: 4, y: 4))
                                                        .shadow(.inner(color: Color.white.opacity(0.9), radius: 5, x: -4, y: -4))
                                                )
                                        }
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: isSelected
                                                        ? [Color.white.opacity(0.8), Color.clear, Color.black.opacity(0.05)]
                                                        : [Color.black.opacity(0.15), Color.clear, Color.white.opacity(0.8)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )

                                // 선택 시 보라색 동그라미
                                Circle()
                                    .fill(viewModel.selectedTheaterIndex == index ? Color(.purple03) : Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                            .id(index)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedTheaterIndex = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .onChange(of: viewModel.selectedTheaterIndex) { _, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
    }

    // MARK: - 특별관 카드 (PageControl + 로고 연동)

    private var specialTheaterCard: some View {
        TabView(selection: $viewModel.selectedTheaterIndex) {
            ForEach(Array(viewModel.theaters.enumerated()), id: \.offset) { index, theater in
                ZStack(alignment: .topLeading) {
                    GeometryReader { geo in
                        Image(theater.card)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 408)
                            .clipped()
                    }

                    LinearGradient(
                        colors: [.black.opacity(0.7), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )

                    VStack(alignment: .leading, spacing: 11) {
                        Text(theater.title)
                            .font(.pretendardBold28)
                        Text(theater.description)
                            .font(.pretendardMedium18)
                    }
                    .foregroundStyle(.white)
                    .padding(20)
                }
                .frame(height: 408)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 428)
        .onChange(of: viewModel.selectedTheaterIndex) { _, _ in }
    }
}

#Preview {
    HomeView()
        .environment(NavigationRouter<HomeRoute>())
        .environment(DIContainer())
}
