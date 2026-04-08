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

    // MARK: - 데이터

    let movies: [MovieModel] = [
        MovieModel(
            title: "왕과 사는 남자",
            posterImage: "kingsWarden",
            audienceCount: 1000,
            englishTitle: "The King's Warden",
            quote: "",
            description: "",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.02.04 · 개봉 · 117분",
            genre: "드라마, 사극",
            type: "2D",
            director: "장항준",
            cast: "유해진, 박지훈, 유지태, 전미도, 안재홍, 김민"
        ),
        MovieModel(
            title: "프로젝트 헤일메리",
            posterImage: "project",
            audienceCount: 120,
            englishTitle: "Project Hail Mary",
            quote: "",
            description: "",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.03.18 · 개봉 · 142분",
            genre: "SF, 스릴러",
            type: "2D, IMAX, 4DX",
            director: "필 로드, 크리스토퍼 밀러",
            cast: "라이언 고슬링, 산드라 휠러"
        ),
        MovieModel(
            title: "호퍼스",
            posterImage: "hoppers",
            audienceCount: 210,
            englishTitle: "Hoppers",
            quote: "",
            description: "",
            rating: "전체 관람가",
            releaseInfo: "2026.03.04 · 개봉 · 104분",
            genre: "애니메이션, 코미디",
            type: "2D, 더빙, 자막",
            director: "대니얼 총",
            cast: "파이퍼 커다, 바비 모니한, 존 햄"
        ),
        MovieModel(
            title: "휴민트",
            posterImage: "humint",
            audienceCount: 450,
            englishTitle: "HUMINT",
            quote: "",
            description: "",
            rating: "15세 이상 관람가",
            releaseInfo: "2026.04 · 개봉 예정",
            genre: "액션, 스파이",
            type: "2D, IMAX",
            director: "류승완",
            cast: "조인성, 박정민, 박해준, 나나"
        ),
        MovieModel(
            title: "매드 댄스 오피스",
            posterImage: "madDance",
            audienceCount: 85,
            englishTitle: "Mad Dance Office",
            quote: "",
            description: "",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.03.04 · 개봉",
            genre: "코미디, 드라마",
            type: "2D",
            director: "조현진",
            cast: "염혜란, 최성은, 아린, 박호산"
        ),
        MovieModel(
            title: "메소드 연기",
            posterImage: "method",
            audienceCount: 0,
            englishTitle: "Method Acting",
            quote: "",
            description: "",
            rating: "12세 이상 관람가",
            releaseInfo: "2026 · 개봉 예정",
            genre: "코미디, 드라마",
            type: "2D",
            director: "이기혁",
            cast: "이동휘, 강찬희, 윤경호"
        ),
        MovieModel(
            title: "28년 후",
            posterImage: "years",
            audienceCount: 300,
            englishTitle: "28 Years Later",
            quote: "",
            description: "",
            rating: "청소년 관람불가",
            releaseInfo: "2026.02.27 · 개봉",
            genre: "공포, 스릴러",
            type: "2D, IMAX",
            director: "대니 보일",
            cast: "킬리언 머피, 조디 코머, 애런 테일러존슨"
        )
    ]

    let theaterBranches = ["강남", "홍대", "신촌"]
    let dates: [CalendarDay] = CalendarDay.generateWeek()

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
                    self.generateShowtimes(theaters: theaters, date: date!)
                } else {
                    self.showtimes = [:]
                    self.emptyTheaters = []
                    self.noShowtimeMessage = nil
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - 상영시간 데이터 생성 (다중 극장 지원)

    private func generateShowtimes(theaters: Set<String>, date: CalendarDay) {
        noShowtimeMessage = nil

        // 첫째날(오늘)만 상영시간 데이터가 있다고 가정
        guard date.isToday else {
            showtimes = [:]
            emptyTheaters = []
            noShowtimeMessage = "선택한 날짜에 상영시간표가 없습니다"
            return
        }

        // 선택된 극장들의 상영시간을 합산 + 데이터 없는 극장 추적
        var merged: [String: [ShowtimeModel]] = [:]
        var emptyBranches: [String] = []

        for branch in theaterBranches where theaters.contains(branch) {
            switch branch {
            case "강남":
                merged["르 리클라이너 1관"] = [
                    ShowtimeModel(theaterBranch: "강남", screenName: "르 리클라이너 1관", format: "2D", time: "11:30", endTime: "~13:58", totalSeats: 116, remainingSeats: 109),
                    ShowtimeModel(theaterBranch: "강남", screenName: "르 리클라이너 1관", format: "2D", time: "14:20", endTime: "~16:48", totalSeats: 116, remainingSeats: 19),
                    ShowtimeModel(theaterBranch: "강남", screenName: "르 리클라이너 1관", format: "2D", time: "17:05", endTime: "~19:28", totalSeats: 116, remainingSeats: 1),
                    ShowtimeModel(theaterBranch: "강남", screenName: "르 리클라이너 1관", format: "2D", time: "19:45", endTime: "~22:02", totalSeats: 116, remainingSeats: 100),
                    ShowtimeModel(theaterBranch: "강남", screenName: "르 리클라이너 1관", format: "2D", time: "22:20", endTime: "~00:04", totalSeats: 116, remainingSeats: 116)
                ]
            case "홍대":
                merged["BTS관 (7층 1관 [Laser])"] = [
                    ShowtimeModel(theaterBranch: "홍대", screenName: "BTS관 (7층 1관 [Laser])", format: "2D", time: "9:30", endTime: "~11:50", totalSeats: 116, remainingSeats: 75),
                    ShowtimeModel(theaterBranch: "홍대", screenName: "BTS관 (7층 1관 [Laser])", format: "2D", time: "12:00", endTime: "~14:26", totalSeats: 116, remainingSeats: 102),
                    ShowtimeModel(theaterBranch: "홍대", screenName: "BTS관 (7층 1관 [Laser])", format: "2D", time: "14:45", endTime: "~17:04", totalSeats: 116, remainingSeats: 88)
                ]
                merged["BTS관 (9층 2관 [Laser])"] = [
                    ShowtimeModel(theaterBranch: "홍대", screenName: "BTS관 (9층 2관 [Laser])", format: "2D", time: "11:30", endTime: "~13:58", totalSeats: 116, remainingSeats: 34),
                    ShowtimeModel(theaterBranch: "홍대", screenName: "BTS관 (9층 2관 [Laser])", format: "2D", time: "14:10", endTime: "~16:32", totalSeats: 116, remainingSeats: 100),
                    ShowtimeModel(theaterBranch: "홍대", screenName: "BTS관 (9층 2관 [Laser])", format: "2D", time: "16:50", endTime: "~19:00", totalSeats: 116, remainingSeats: 13),
                    ShowtimeModel(theaterBranch: "홍대", screenName: "BTS관 (9층 2관 [Laser])", format: "2D", time: "19:20", endTime: "~21:40", totalSeats: 116, remainingSeats: 92)
                ]
            default:
                // 신촌 등 상영시간표가 없는 극장
                emptyBranches.append(branch)
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

    // 상영관별 정렬된 키 반환 — theaterBranches 순서(강남→홍대→신촌) 기준 정렬
    var sortedScreenNames: [String] {
        showtimes.keys.sorted { a, b in
            let branchA = showtimes[a]?.first?.theaterBranch ?? ""
            let branchB = showtimes[b]?.first?.theaterBranch ?? ""
            let indexA = theaterBranches.firstIndex(of: branchA) ?? Int.max
            let indexB = theaterBranches.firstIndex(of: branchB) ?? Int.max
            // 같은 극장 내 상영관은 Natural Sort (숫자 인식 정렬: "2관" < "10관")
            if indexA == indexB { return a.localizedStandardCompare(b) == .orderedAscending }
            return indexA < indexB
        }
    }
}
