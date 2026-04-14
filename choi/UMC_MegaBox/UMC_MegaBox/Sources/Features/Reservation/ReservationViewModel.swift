import Foundation
import Combine

@Observable
class ReservationViewModel {

    // MARK: - 선택 상태 (View 바인딩용)

    var selectedMovie: MovieModel? {
        didSet {
            movieSubject.send(selectedMovie)
            // 극장/날짜 유지 → 영화만 바꿔가며 시간표 비교 가능
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
    var noShowtimeMessage: String? = nil
    var showtimes: [String: [ShowtimeModel]] = [:]  // screenName -> [ShowtimeModel]
    var emptyTheaters: [String] = []                 // 상영시간표가 없는 극장 목록

    // MARK: - 데이터 (Provider에서 주입)

    let movies: [MovieModel]
    let theaterBranches: [String]
    let dates: [CalendarDay] = CalendarDay.generateWeek()

    // MARK: - Sheet 상태

    var isMovieSearchPresented: Bool = false

    // MARK: - Combine

    private let movieSubject = CurrentValueSubject<MovieModel?, Never>(nil)
    private let theatersSubject = CurrentValueSubject<Set<String>, Never>([])
    private let dateSubject = CurrentValueSubject<CalendarDay?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - 의존성

    private let dataProvider: MovieDataProviding

    // MARK: - Init

    init(dataProvider: MovieDataProviding = HardcodedMovieDataProvider()) {
        self.dataProvider = dataProvider
        self.movies = dataProvider.reservationMovies
        self.theaterBranches = dataProvider.theaterBranches
        setupCombineChain()
    }

    // MARK: - Combine 의존성 체인 설정

    private func setupCombineChain() {

        // 1) 영화 선택 → 극장 활성화
        movieSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                guard let self else { return }
                self.isTheaterEnabled = (movie != nil)
            }
            .store(in: &cancellables)

        // 2) 극장 선택 → 날짜 활성화 (영화도 선택되어 있어야 하고, 극장이 1개 이상)
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
                    let result = self.dataProvider.generateShowtimes(theaters: theaters, date: date!)
                    self.showtimes = result.showtimes
                    self.emptyTheaters = result.emptyTheaters
                    self.noShowtimeMessage = result.noShowtimeMessage
                } else {
                    self.showtimes = [:]
                    self.emptyTheaters = []
                    self.noShowtimeMessage = nil
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - 액션

    func selectMovie(_ movie: MovieModel) {
        selectedMovie = movie
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
}
