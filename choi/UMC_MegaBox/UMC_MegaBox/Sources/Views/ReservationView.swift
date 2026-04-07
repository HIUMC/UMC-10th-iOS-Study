import SwiftUI

struct ReservationView: View {
    @Environment(NavigationRouter<ReservationRoute>.self) private var router
    @State private var viewModel = ReservationViewModel()

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.path) {
            ZStack(alignment: .top) {
                // 배경
                Color(.purple00).ignoresSafeArea()

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
                case .seatSelection(let movie, let branch, let showtime):
                    SeatSelectionView(movie: movie, theaterBranch: branch, showtime: showtime)
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
            Text("영화별 예매")
                .font(.pretendardBold18)
                .foregroundStyle(.white)
                .padding(.bottom, 12)
        }
        .frame(height: 50)
    }

    // MARK: - 선택된 영화 정보 + 전체영화 버튼

    private var selectedMovieHeader: some View {
        HStack {
            if let movie = viewModel.selectedMovie {
                // 관람등급 배지
                ratingBadge(movie.rating)

                Text(movie.title)
                    .font(.pretendardBold18)
                    .foregroundStyle(Color(.gray07))
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
                    .font(.pretendardSemiBold12)
                    .foregroundStyle(Color(.gray05))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.gray02), lineWidth: 1)
                    )
            }
        }
    }

    // MARK: - 관람등급 배지

    private func ratingBadge(_ rating: String) -> some View {
        let label: String
        let bgColor: Color

        switch rating {
        case "전체 관람가":
            label = "ALL"
            bgColor = .green
        case "12세 이상 관람가":
            label = "12"
            bgColor = Color(.blue03)
        case "15세 이상 관람가":
            label = "15"
            bgColor = .orange
        case "청소년 관람불가":
            label = "19"
            bgColor = .red
        default:
            label = "-"
            bgColor = .gray
        }

        return Text(label)
            .font(.pretendardSemiBold12)
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(bgColor)
            .cornerRadius(4)
    }

    // MARK: - 영화 포스터 가로 스크롤

    private var movieCardScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
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
                .frame(width: 100, height: 140)
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
        .frame(width: 100, height: 140)
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
        let isSelected = viewModel.selectedTheater == branch
        let isEnabled = viewModel.isTheaterEnabled

        return Button {
            guard isEnabled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectTheater(branch)
            }
        } label: {
            Text(branch)
                .font(.pretendardSemiBold14)
                .foregroundStyle(
                    !isEnabled ? Color(.gray02)
                    : isSelected ? .white
                    : Color(.gray05)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(.purple03) : Color.clear)
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
        HStack(spacing: 0) {
            ForEach(viewModel.dates) { day in
                dateCellView(day)
            }
            Spacer()
        }
    }

    private func dateCellView(_ day: CalendarDay) -> some View {
        let isSelected = viewModel.selectedDate?.id == day.id
        let isEnabled = viewModel.isDateEnabled

        // 요일 텍스트 색상 결정
        let weekdayColor: Color = {
            if !isEnabled { return Color(.gray02) }
            if isSelected { return .white }
            if day.isSunday { return Color(.sunday) }
            if day.isSaturday { return Color(.saturday) }
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

                // 요일 (오늘은 "오늘")
                Text(day.isToday ? "오늘" : day.weekdaySymbol)
                    .font(.pretendardMedium10)
                    .foregroundStyle(weekdayColor)
            }
            .frame(width: 44, height: 56)
            .background(
                isSelected
                    ? (day.isToday ? Color(.purple03) : Color(.purple03))
                    : (day.isToday ? Color(.purple00) : Color.clear)
            )
            .cornerRadius(8)
        }
        .disabled(!isEnabled)
    }

    // MARK: - 상영시간 섹션

    private var showtimeSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 메시지 표시 (신촌 또는 상영시간 없는 날짜)
            if let message = viewModel.noShowtimeMessage {
                Text(message)
                    .font(.pretendardMedium14)
                    .foregroundStyle(Color(.gray04))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                // 극장별 그룹
                ForEach(viewModel.sortedScreenNames, id: \.self) { screenName in
                    if let times = viewModel.showtimes[screenName] {
                        showtimeGroup(
                            theaterBranch: viewModel.selectedTheater ?? "",
                            screenName: screenName,
                            format: times.first?.format ?? "2D",
                            showtimes: times
                        )
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
                .padding(.vertical, 8)
        }
    }

    private func showtimeCard(_ showtime: ShowtimeModel) -> some View {
        Button {
            if let movie = viewModel.selectedMovie {
                router.push(.seatSelection(movie, showtime.theaterBranch, showtime))
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
