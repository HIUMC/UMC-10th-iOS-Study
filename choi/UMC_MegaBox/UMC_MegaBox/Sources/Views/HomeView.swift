import SwiftUI

struct HomeView: View {
    @Environment(NavigationRouter<HomeRoute>.self) private var router
    @State private var viewModel = HomeViewModel()
    @State private var selectedSegment: Int = 0
    @State private var selectedTheaterIndex: Int = 0

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
                        .foregroundStyle(tab == "홈" ? Color(.purple03) : Color(.gray03))
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
            Button(action: { selectedSegment = 0 }) {
                Text("무비차트")
                    .font(.pretendardSemiBold14)
                    .foregroundStyle(selectedSegment == 0 ? .white : Color(.gray03))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(selectedSegment == 0 ? Color(.purple03) : Color.clear)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(selectedSegment == 0 ? Color.clear : Color(.gray02), lineWidth: 1)
                    )
            }

            Button(action: { selectedSegment = 1 }) {
                Text("상영예정")
                    .font(.pretendardSemiBold14)
                    .foregroundStyle(selectedSegment == 1 ? .white : Color(.gray03))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(selectedSegment == 1 ? Color(.purple03) : Color.clear)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(selectedSegment == 1 ? Color.clear : Color(.gray02), lineWidth: 1)
                    )
            }

            Spacer()
        }
    }

    // MARK: - 무비카드 가로 스크롤

    private var movieCardScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.movies) { movie in
                    makeMovieCard(movie)
                        .onTapGesture {
                            router.push(.movieDetail(movie))
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func makeMovieCard(_ movie: MovieModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(movie.posterImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 200)
                .clipped()
                .cornerRadius(8)

            Button(action: {}) {
                Text("바로 예매")
                    .font(.pretendardSemiBold12)
                    .foregroundStyle(Color(.purple03))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.purple03), lineWidth: 1)
                    )
            }
            .padding(.top, 8)

            Text(movie.title)
                .font(.pretendardSemiBold14)
                .foregroundStyle(Color(.gray07))
                .lineLimit(1)
                .padding(.top, 8)

            Text(movie.formattedAudienceCount)
                .font(.pretendardRegular12)
                .foregroundStyle(Color(.gray03))
                .padding(.top, 2)
        }
        .frame(width: 140)
    }

    // MARK: - 메가박스의 모든 특별관

    private var specialTheaterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("메가박스의 모든 특별관")
                    .font(.pretendardBold24)
                    .foregroundStyle(Color(.black))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(.gray03))
            }
            .padding(.horizontal, 20)

            // 특별관 로고 가로 스크롤
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(Array(viewModel.theaters.enumerated()), id: \.offset) { index, theater in
                        VStack(spacing: 4) {
                            let isSelected = (selectedTheaterIndex == index)

                            Image(theater.logo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(10)
                                .background{
                                    Image(theater.logo)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .padding(10)
                                            .background {
                                                if isSelected {
                                                    //[선택됨] 밝은 색상(하얀색) + 볼록하게 튀어나온 느낌
                                                    Circle()
                                                        .fill(Color.white) 
                                                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 4, y: 4)
                                                        .shadow(color: Color.white.opacity(0.9), radius: 6, x: -4, y: -4)
                                                } else {
                                                    // 🔘 [선택 안 됨] 기존 회색 배경 + 오목하게 눌린 느낌
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
                                }
                                 
                            // 선택 시 보라색 동그라미
                            Circle()
                                .fill(selectedTheaterIndex == index ? Color(.purple03) : Color.clear)
                                .frame(width: 6, height: 6)
                        }
                        .onTapGesture {
                            withAnimation {
                                selectedTheaterIndex = index
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - 특별관 카드 (PageControl + 로고 연동)

    private var specialTheaterCard: some View {
        TabView(selection: $selectedTheaterIndex) {
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
        .onChange(of: selectedTheaterIndex) { _, _ in }
    }
}

#Preview {
    HomeView()
        .environment(NavigationRouter<HomeRoute>())
}
