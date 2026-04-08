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
                case .seatSelection(let movie, let branch, let showtime, let date):
                    SeatSelectionView(movie: movie, theaterBranch: branch, showtime: showtime, selectedDate: date)
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
                        dateCellView(day)
                    }
                }
    }

    private func dateCellView(_ day: CalendarDay) -> some View {
        let isSelected = viewModel.selectedDate?.id == day.id
        let isEnabled = viewModel.isDateEnabled

        // 요일 텍스트 색상 결정
        let weekdayColor: Color = {
            if !isEnabled { return Color(.gray02) }
            if isSelected { return .white }
            return Color(.gray07)
        }()

        // 날짜 숫자 색상
        let dayNumberColor: Color = {
            if !isEnabled { return Color(.gray02) }
            if isSelected { return .white }
            if day.isSunday { return Color(.sunday) }
            if day.isSaturday { return Color(.saturday) }
            return Color(.gray07)
        }()

        // 요일 텍스트를 결정하는 변수
        let weekdayString: String
                if day.isToday {
                    weekdayString = "오늘"
                } else if day.isTomorrow {
                    weekdayString = "내일"
                } else {
                    weekdayString = day.weekdaySymbol
        }

        return Button {
            guard isEnabled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectDate(day)
            }
        } label: {
            VStack(spacing: 4) {
                // 날짜 숫자 (월.일 형태 for 오늘, 아니면 숫자만)
                if day.isToday {
                    Text("\(Calendar.current.component(.month, from: day.date)).\(day.day)")
                        .font(.pretendardBold18)
                        .foregroundStyle(dayNumberColor)
                } else {
                    Text("\(day.day)")
                        .font(.pretendardBold18)
                        .foregroundStyle(dayNumberColor)
                }

                // 요일 (오늘은 "오늘", 내일은 "내일")
                Text(weekdayString)
                    .font(.pretendardSemiBold14)
                    .foregroundStyle(weekdayColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                isSelected ? Color(.purple03) : Color.clear)
            .cornerRadius(8)
        }
        
        .disabled(!isEnabled)
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
                // 상영시간이 있는 극장별 그룹
                ForEach(viewModel.sortedScreenNames, id: \.self) { screenName in
                    if let times = viewModel.showtimes[screenName] {
                        showtimeGroup(
                            theaterBranch: times.first?.theaterBranch ?? "",
                            screenName: screenName,
                            format: times.first?.format ?? "2D",
                            showtimes: times
                        )
                    }
                }

                // 상영시간표가 없는 극장 Empty State (예: 신촌)
                ForEach(viewModel.emptyTheaters, id: \.self) { branch in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(branch)
                            .font(.pretendardBold18)
                            .foregroundStyle(Color(.gray07))

                        Text("선택한 극장에 상영시간표가 없습니다")
                            .font(.pretendardMedium14)
                            .foregroundStyle(Color(.gray03))
                            .padding(.vertical, 20)

                        Divider()
                            .background(Color(.gray01))
                            .padding(.vertical, 8)
                    }
                }
            }
        }
    }

    private func showtimeGroup(
        theaterBranch: String,
        screenName: String,
        format: String,
        showtimes: [ShowtimeModel]
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 극장 이름
            Text(theaterBranch)
                .font(.pretendardBold18)
                .foregroundStyle(Color(.gray07))
                .padding(.bottom, 4)

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

            // 상영시간 카드 그리드
            let columns = [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ]

            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(showtimes) { showtime in
                    showtimeCard(showtime)
                }
            }

            Divider()
                .background(Color(.gray01))
                .padding(.vertical, 20)
        }
    }

    private func showtimeCard(_ showtime: ShowtimeModel) -> some View {
        Button {
            if let movie = viewModel.selectedMovie,
               let date = viewModel.selectedDate{
                router.push(.seatSelection(movie, showtime.theaterBranch, showtime, date))
            }
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(showtime.time)
                    .font(.pretendardBold18)
                    .foregroundStyle(Color(.gray07))

                Text(showtime.endTime)
                    .font(.pretendardRegular12)
                    .foregroundStyle(Color(.gray03))

                HStack(spacing: 2) {
                    Text("\(showtime.remainingSeats)")
                        .font(.pretendardSemiBold12)
                        .foregroundStyle(seatCountColor(remaining: showtime.remainingSeats, total: showtime.totalSeats))
                    Text("/ \(showtime.totalSeats)")
                        .font(.pretendardRegular12)
                        .foregroundStyle(Color(.gray03))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color(.white))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.gray01), lineWidth: 1)
            )
        }
    }

    // 잔여 좌석 수에 따른 색상
    private func seatCountColor(remaining: Int, total: Int) -> Color {
        let ratio = Double(remaining) / Double(total)
        if ratio <= 0.1 { return .red }
        if ratio <= 0.3 { return .orange }
        return Color(.purple03)
    }
}

#Preview {
    ReservationView()
        .environment(NavigationRouter<ReservationRoute>())
        .environment(DIContainer())
}
