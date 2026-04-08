import SwiftUI

struct ReservationView: View {
    @Environment(NavigationRouter<ReservationRoute>.self) private var router
    @State private var viewModel = ReservationViewModel()

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.path) {
            ZStack(alignment: .top) {
                // 배경
                Color(.white).ignoresSafeArea()

                VStack(spacing: 0) {
                    // 보라색 상단 네비바
                    headerBar
                    // 스크롤 콘텐츠
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            // 선택된 영화 정보 + 전체영화 버튼
                            selectedMovieHeader
                                .padding(.top, 12)
                                .padding(.horizontal, 20)

                            // 영화 포스터 가로 스크롤
                            movieCardScroll
                                .padding(.top, 16)

                            // 극장 선택 버튼
                            theaterSection
                                .padding(.top, 20)
                                .padding(.horizontal, 20)

                            // 날짜 선택
                            dateSection
                                .padding(.top, 16)
                                .padding(.horizontal, 20)

                            // 상영시간 섹션
                            if viewModel.isShowtimeVisible {
                                showtimeSection
                                    .padding(.top, 24)
                                    .padding(.horizontal, 20)
                            }

                            Spacer().frame(height: 40)
                        }
                    }
                }
            }
            .navigationDestination(for: ReservationRoute.self) { route in
                switch route {
                case .seatSelection(let params):
                    SeatSelectionView(params: params)
                }
            }
            .sheet(isPresented: $viewModel.isMovieSearchPresented) {
                MovieSearchView(movies: viewModel.movies) { selected in
                    viewModel.selectMovie(selected)
                }
            }
        }
    }

    // MARK: - 상단 보라색 헤더

    private var headerBar: some View {
        ZStack {
            Color(.purple03)
                .ignoresSafeArea(edges: .top)
            Text("영화별 예매")
                .font(.pretendardBold18)
                .foregroundStyle(.white)
                .padding(.bottom, 10)
            
        }
        .frame(height: 41)
        
        
    }

    // MARK: - 선택된 영화 정보 + 전체영화 버튼

    private var selectedMovieHeader: some View {
        HStack {
            if let movie = viewModel.selectedMovie {
                // 관람등급 배지
                ratingBadge(movie.rating)
                    .padding(.trailing, 15)
                Text(movie.title)
                    .font(.pretendardBold18)
                    .foregroundStyle(Color(.black))
                    .lineLimit(1)
            } else {
                Text("영화를 선택해주세요")
                    .font(.pretendardBold18)
                    .foregroundStyle(Color(.gray03))
            }

            Spacer()

            Button {
                viewModel.isMovieSearchPresented = true
            } label: {
                Text("전체영화")
                    .font(.pretendardSemiBold14)
                    .foregroundStyle(Color(.black))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
            }
            .glassEffect()

        }
    }

    // MARK: - 관람등급 배지

    private func ratingBadge(_ rating: String) -> some View {
        let label: String
        let bgColor: Color

        switch rating {
        case "전체 관람가":
            label = "All"
            bgColor = .green
        case "12세 이상 관람가":
            label = "12"
            bgColor = .orange
        case "15세 이상 관람가":
            label = "15"
            bgColor = Color(.blue03)
        case "청소년 관람불가":
            label = "19"
            bgColor = .red
        default:
            label = "-"
            bgColor = .gray
        }

        return Text(label)
            .font(.pretendardSemiBold18)
            .foregroundStyle(.white)
            .frame(width: 23, height: 24)
            .background(bgColor)
            .cornerRadius(4)
    }

    // MARK: - 영화 포스터 가로 스크롤

    private var movieCardScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(viewModel.movies) { movie in
                    moviePosterCard(movie)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectMovie(movie)
                            }
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func moviePosterCard(_ movie: MovieModel) -> some View {
        let isSelected = viewModel.selectedMovie?.id == movie.id

        return ZStack(alignment: .bottom) {
            Image(movie.posterImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 63, height: 89)
                .clipped()
                .cornerRadius(8)

            // 선택된 영화: 하단에 제목 오버레이
            if isSelected {
                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .cornerRadius(8)
                    
                    Text(movie.title)
                        .font(.pretendardSemiBold12)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)

                }
            }
        }
        .frame(width: 63, height: 89)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color(.purple03) : Color.clear, lineWidth: 3)
        )
    }

    // MARK: - 극장 선택 섹션

    private var theaterSection: some View {
        HStack(spacing: 10) {
            ForEach(viewModel.theaterBranches, id: \.self) { branch in
                theaterButton(branch)
            }
            Spacer()
        }
    }

    private func theaterButton(_ branch: String) -> some View {
        let isSelected = viewModel.selectedTheaters.contains(branch)
        let isEnabled = viewModel.isTheaterEnabled

        return Button {
            guard isEnabled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.toggleTheater(branch)
            }
        } label: {
            Text(branch)
                .font(.pretendardSemiBold14)
                .foregroundStyle(
                    !isEnabled ? Color(.gray05)
                    : isSelected ? .white
                    : Color(.gray05)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(.purple03) : Color(.gray01))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            !isEnabled ? Color(.gray01)
                            : isSelected ? Color.clear
                            : Color(.gray02),
                            lineWidth: 1
                        )
                )
        }
        .disabled(!isEnabled)
    }

    // MARK: - 날짜 선택 섹션

    private var dateSection: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

        return LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.dates) { day in
                DateCellView(
                    day: day,
                    isSelected: viewModel.selectedDate?.id == day.id,
                    isEnabled: viewModel.isDateEnabled
                ) {
                    viewModel.selectDate(day)
                }
            }
        }
    }

    // MARK: - 상영시간 섹션

    private var showtimeSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 전체 메시지 (선택된 극장 전부 데이터 없음 or 날짜 없음)
            if let message = viewModel.noShowtimeMessage, viewModel.showtimes.isEmpty {
                Text(message)
                    .font(.pretendardMedium14)
                    .foregroundStyle(Color(.gray04))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                // 지점별 이중 루프: Branch → ScreenNames
                ForEach(Array(viewModel.groupedByBranch.enumerated()), id: \.offset) { index, group in
                    branchGroup(branch: group.branch, screenNames: group.screenNames)

                    // 지점 그룹 간 Divider + 24px
                    if index < viewModel.groupedByBranch.count - 1 || !viewModel.emptyTheaters.isEmpty {
                        Divider().background(Color(.gray01))
                            .padding(.vertical, 24)
                    }
                }

                // 상영시간표가 없는 극장 Empty State (예: 신촌)
                ForEach(Array(viewModel.emptyTheaters.enumerated()), id: \.offset) { index, branch in
                    emptyBranchGroup(branch: branch)

                    if index < viewModel.emptyTheaters.count - 1 {
                        Divider().background(Color(.gray01))
                            .padding(.vertical, 12)
                    }
                }
            }
        }
    }

    // MARK: - 지점 그룹 (지점명 1회 + 내부 상영관 N개)

    private func branchGroup(branch: String, screenNames: [String]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // 지점명
            Text(branch)
                .font(.pretendardBold18)
                .foregroundStyle(Color(.gray07))

            // 지점명 ↔ 첫 번째 상영관: 16px
            // 상영관 묶음 간: 20px
            VStack(alignment: .leading, spacing: 20) {
                ForEach(screenNames, id: \.self) { screenName in
                    if let times = viewModel.showtimes[screenName] {
                        screenGroup(
                            screenName: screenName,
                            format: times.first?.format ?? "2D",
                            showtimes: times
                        )
                    }
                }
            }
            .padding(.top, 16)
        }
    }

    // MARK: - 상영관 단위 (상영관명 + 시간표 그리드)

    private func screenGroup(
        screenName: String,
        format: String,
        showtimes: [ShowtimeModel]
    ) -> some View {
        let columns = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]

        return VStack(alignment: .leading, spacing: 12) {
            // 상영관 + 포맷
            HStack {
                Text(screenName)
                    .font(.pretendardSemiBold14)
                    .foregroundStyle(Color(.gray07))
                Spacer()
                Text(format)
                    .font(.pretendardSemiBold12)
                    .foregroundStyle(Color(.gray04))
            }

            // 상영관 타이틀 ↔ 시간표 그리드: 12px (spacing)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(showtimes) { showtime in
                    ShowtimeCardView(showtime: showtime) {
                        if let movie = viewModel.selectedMovie,
                           let date = viewModel.selectedDate {
                            router.push(.seatSelection(SeatSelectionParams(
                                movie: movie,
                                theaterBranch: showtime.theaterBranch,
                                showtime: showtime,
                                selectedDate: date
                            )))
                        }
                    }
                }
            }
        }
    }

    // MARK: - Empty State 지점 그룹

    private func emptyBranchGroup(branch: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(branch)
                .font(.pretendardBold18)
                .foregroundStyle(Color(.gray07))

            Text("선택한 극장에 상영시간표가 없습니다")
                .font(.pretendardMedium14)
                .foregroundStyle(Color(.gray03))
                .padding(.vertical, 12)
        }
    }

}

#Preview {
    ReservationView()
        .environment(NavigationRouter<ReservationRoute>())
        .environment(DIContainer())
}
