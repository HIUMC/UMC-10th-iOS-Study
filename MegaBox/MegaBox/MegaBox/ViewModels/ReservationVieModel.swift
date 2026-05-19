import Foundation
import Combine

@Observable
class ReservationViewModel {

    // MARK: - 선택 상태 (View 바인딩용)

    var selectedMovieIndex: Int?
    var selectedMovie: MovieModel? {
        didSet {
            updateFilteredScheduleMetadata()
            movieSubject.send(selectedMovie)
        }
    }
    var selectedTheaters: Set<String> = [] {
        didSet {
            theatersSubject.send(selectedTheaters)
            // 날짜 유지 → 극장만 토글하며 시간표 비교 가능
        }
    }
    var selectedDate: CalendarDay? {
        didSet { dateSubject.send(selectedDate) }
    }

    // MARK: - Combine으로 파생되는 상태

    var isTheaterEnabled: Bool = false
    var isDateEnabled: Bool = false
    var isShowtimeVisible: Bool = false
    var isLoadingSchedules: Bool = false
    var noShowtimeMessage: String? = nil
    var scheduleLoadErrorMessage: String? = nil
    var showtimes: [String: [TimeTableModel]] = [:]  // screenName -> [ShowtimeModel]
    var emptyTheaters: [String] = []                 // 상영시간표가 없는 극장 목록
    var reservationResponse: ReservationResponseModel?
    var reservationMovies: [ReservationMovieModel] = []
    var filteredTheaterBranches: [String] = []
    var filteredDates: [CalendarDay] = []

    // MARK: - 데이터

    var movies: [MovieModel] = []
    var theaterBranches: [String] = []
    var dates: [CalendarDay] = []

    // MARK: - Sheet 상태

    var isMovieSearchPresented: Bool = false

    // MARK: - Combine

    private let movieSubject = CurrentValueSubject<MovieModel?, Never>(nil)
    private let theatersSubject = CurrentValueSubject<Set<String>, Never>([])
    private let dateSubject = CurrentValueSubject<CalendarDay?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        setupCombineChain()
        Task {
            await loadMovieSchedules()
        }
    }

    // MARK: - Combine 의존성 체인 설정

    private func setupCombineChain() {

        // 1) 영화 선택 → 극장 활성화
        //    하위 리셋은 didSet 연쇄에서 처리, 여기서는 파생 상태만 관리
        movieSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                guard let self else { return }
                self.isTheaterEnabled = (movie != nil)
            }
            .store(in: &cancellables)

        // 2) 극장 선택 → 날짜 활성화 (영화도 선택되어 있어야 하고, 극장이 1개 이상)
        //    하위 리셋은 didSet 연쇄에서 처리, 여기서는 파생 상태만 관리
        theatersSubject
            .combineLatest(movieSubject)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] theaters, movie in
                guard let self else { return }
                self.isDateEnabled = (!theaters.isEmpty && movie != nil)
            }
            .store(in: &cancellables)

        // 3) 영화 + 극장(1개 이상) + 날짜 모두 선택 → 상영시간 노출
        movieSubject
            .combineLatest(theatersSubject, dateSubject)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie, theaters, date in
                guard let self else { return }

                let allSelected = (movie != nil && !theaters.isEmpty && date != nil)
                self.isShowtimeVisible = allSelected

                if allSelected {
                    self.generateShowtimes(movie: movie!, theaters: theaters, date: date!)
                } else {
                    self.showtimes = [:]
                    self.emptyTheaters = []
                    self.noShowtimeMessage = nil
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Local JSON Load

    func loadMovieSchedules() async {
        await MainActor.run {
            isLoadingSchedules = true
            scheduleLoadErrorMessage = nil
        }

        do {
            let response = try await fetchMovieSchedulesFromBundle()

            await MainActor.run {
                reservationResponse = response
                reservationMovies = response.data.movies
                configureReservationContent(using: response)
                if selectedMovie == nil, !movies.isEmpty {
                    setSelectedMovie(at: 0)
                } else {
                    updateFilteredScheduleMetadata()
                }
                isLoadingSchedules = false
            }
        } catch {
            await MainActor.run {
                reservationResponse = nil
                reservationMovies = []
                movies = []
                theaterBranches = []
                dates = []
                filteredTheaterBranches = []
                filteredDates = []
                isLoadingSchedules = false
                scheduleLoadErrorMessage = error.localizedDescription
            }

            print("MovieSchedule.json load failed: \(error.localizedDescription)")
        }
    }

    private func fetchMovieSchedulesFromBundle() async throws -> ReservationResponseModel {
        try await Task.detached(priority: .userInitiated) {
            guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
                throw ReservationDataLoadError.fileNotFound
            }

            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let dto = try decoder.decode(ReservationResponseDTO.self, from: data)

                guard let response = dto.toDomain() else {
                    throw ReservationDataLoadError.invalidDomainMapping
                }

                return response
            } catch let error as ReservationDataLoadError {
                throw error
            } catch let decodingError as DecodingError {
                print("MovieSchedule.json decode failed: \(decodingError)")
                throw ReservationDataLoadError.decodingFailed(decodingError)
            } catch {
                print("MovieSchedule.json read failed: \(error)")
                throw ReservationDataLoadError.readFailed(error)
            }
        }.value
    }

    private func configureReservationContent(using response: ReservationResponseModel) {
        let availableReservationMovieIDs = Set(response.data.movies.map(\.id))

        movies = MovieModel.allMovies.filter {
            guard let reservationMovieID = reservationMovieIDByMovieID[$0.id] else {
                return false
            }
            return availableReservationMovieIDs.contains(reservationMovieID)
        }

        let allDates = response.data.movies
            .flatMap(\.schedules)
            .map(\.date)
            .sorted()
        dates = CalendarDay.generateDays(from: Array(NSOrderedSet(array: allDates)) as? [Date] ?? [])

        theaterBranches = response.data.movies
            .flatMap(\.schedules)
            .flatMap(\.areas)
            .map(\.area)
            .reduce(into: [String]()) { result, area in
                if !result.contains(area) {
                    result.append(area)
                }
            }

        filteredTheaterBranches = theaterBranches
        filteredDates = dates
    }

    // MARK: - 상영시간 데이터 생성 (다중 극장 지원)

    private func generateShowtimes(movie: MovieModel, theaters: Set<String>, date: CalendarDay) {
        noShowtimeMessage = nil
        guard let reservationMovie = reservationMovie(for: movie) else {
            showtimes = [:]
            emptyTheaters = Array(theaters).sorted()
            noShowtimeMessage = "선택한 영화의 상영시간표가 없습니다"
            return
        }

        guard let schedule = reservationMovie.schedules.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date.date)
        }) else {
            showtimes = [:]
            emptyTheaters = []
            noShowtimeMessage = "선택한 날짜에 상영시간표가 없습니다"
            return
        }

        var merged: [String: [TimeTableModel]] = [:]
        var emptyBranches: [String] = []

        for branch in theaterBranches where theaters.contains(branch) {
            guard let area = schedule.areas.first(where: { $0.area == branch }) else {
                emptyBranches.append(branch)
                continue
            }

            for item in area.items {
                merged[item.auditorium] = item.showtimes.map {
                    TimeTableModel(
                        theaterBranch: branch,
                        screenName: item.auditorium,
                        format: item.format,
                        time: $0.start,
                        endTime: "~\($0.end)",
                        totalSeats: $0.total,
                        remainingSeats: $0.available
                    )
                }
            }
        }

        showtimes = merged
        emptyTheaters = emptyBranches

        // 선택된 극장 전체가 데이터 없는 경우 (신촌만 선택 등)
        if merged.isEmpty && !emptyBranches.isEmpty {
            noShowtimeMessage = "선택한 극장에 상영시간표가 없습니다"
        }
    }

    // MARK: - 액션

    func selectMovie(_ movie: MovieModel) {
        guard let index = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        setSelectedMovie(at: index)
    }

    func toggleTheater(_ branch: String) {
        if selectedTheaters.contains(branch) {
            selectedTheaters.remove(branch)
        } else {
            selectedTheaters.insert(branch)
        }
    }

    func selectDate(_ day: CalendarDay) {
        selectedDate = day
    }

    // MARK: - 지점별 그룹핑 (View에서 이중 루프용)

    /// 지점별로 그룹핑된 상영관 목록을 theaterBranches 순서대로 반환
    /// 예: [("강남", ["르 리클라이너 1관"]), ("홍대", ["BTS관 (7층 1관)", "BTS관 (9층 2관)"])]
    var groupedByBranch: [(branch: String, screenNames: [String])] {
        // 1. screenName → branch 매핑
        var branchToScreens: [String: [String]] = [:]
        for (screenName, times) in showtimes {
            guard let branch = times.first?.theaterBranch else { continue }
            branchToScreens[branch, default: []].append(screenName)
        }

        // 2. theaterBranches 순서대로 정렬, 같은 지점 내 상영관은 Natural Sort
        return theaterBranches.compactMap { branch in
            guard var screens = branchToScreens[branch] else { return nil }
            screens.sort { $0.localizedStandardCompare($1) == .orderedAscending }
            return (branch: branch, screenNames: screens)
        }
    }

    private func reservationMovie(for movie: MovieModel) -> ReservationMovieModel? {
        guard let reservationMovieID = reservationMovieIDByMovieID[movie.id] else {
            return nil
        }

        return reservationMovies.first(where: { $0.id == reservationMovieID })
    }

    private func updateFilteredScheduleMetadata() {
        guard let selectedMovie, let reservationMovie = reservationMovie(for: selectedMovie) else {
            filteredTheaterBranches = theaterBranches
            filteredDates = dates
            selectedTheaters = []
            selectedDate = nil
            return
        }

        let availableAreas = reservationMovie.schedules
            .flatMap(\.areas)
            .map(\.area)
            .reduce(into: [String]()) { result, area in
                if !result.contains(area) {
                    result.append(area)
                }
            }
        filteredTheaterBranches = availableAreas

        let availableDates = reservationMovie.schedules.map(\.date).sorted()
        filteredDates = CalendarDay.generateDays(from: availableDates)

        selectedTheaters = selectedTheaters.intersection(Set(filteredTheaterBranches))

        if let selectedDate,
           !filteredDates.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate.date) }) {
            self.selectedDate = nil
        }
    }

    private func setSelectedMovie(at index: Int?) {
        guard let index, movies.indices.contains(index) else {
            selectedMovieIndex = nil
            selectedMovie = nil
            return
        }

        selectedMovieIndex = index
        selectedMovie = movies[index]
    }

    private let reservationMovieIDByMovieID: [String: String] = [
        "kings-warden": "m-001",
        "project-hail-mary": "m-002",
        "hoppers": "m-003"
    ]
}

private enum ReservationDataLoadError: LocalizedError {
    case fileNotFound
    case readFailed(Error)
    case decodingFailed(DecodingError)
    case invalidDomainMapping

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "MovieSchedule.json 파일을 찾을 수 없습니다."
        case .readFailed(let error):
            return "MovieSchedule.json 파일을 읽는 데 실패했습니다: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "MovieSchedule.json 디코딩에 실패했습니다: \(error.localizedDescription)"
        case .invalidDomainMapping:
            return "DTO를 도메인 모델로 변환하지 못했습니다."
        }
    }
}
