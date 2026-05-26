import Foundation

@Observable
class HomeViewModel {
    var movies: [MovieModel] = MovieModel.nowPlayingMovies
    var upcomingMovies: [MovieModel] = MovieModel.upcomingMovies
    var isLoadingNowPlayingMovies = false
    var movieLoadingErrorMessage: String?

    private let movieService = TMDBMovieService()
    
    // 무비차트 / 상영예정 구분 enum
    enum MovieChartType {
        case nowPlaying
        case upcoming
    }

    // 선택된 차트 타입에 따라 영화 목록 반환
    func currentMovies(for type: MovieChartType) -> [MovieModel] {
        switch type {
        case .nowPlaying: return movies
        case .upcoming: return upcomingMovies
        }
    }

    @MainActor
    func fetchNowPlayingMovies() async {
        guard !isLoadingNowPlayingMovies else {
            return
        }

        isLoadingNowPlayingMovies = true
        movieLoadingErrorMessage = nil

        do {
            movies = try await movieService.fetchNowPlayingMovies()
        } catch {
            movieLoadingErrorMessage = error.localizedDescription
            print("TMDB Now Playing 호출 실패: \(error.localizedDescription)")
        }

        isLoadingNowPlayingMovies = false
    }

    let theaters: [TheaterModel] = [
        TheaterModel(logo: "Dolby Cinema 로고", card: "Dolby Cinema", name: "Dolby Cinema", title: "DOLBY CINEMA", description: "완벽한 영화 관람을 완성하는\n하이엔드 시네마"),
        TheaterModel(logo: "Dolby Atmos 로고", card: "Dolby Vision+Atmos", name: "Dolby Atmos", title: "DOLBY VISION+ATMOS", description: "돌비 시네마의 선명한 영상과 입도 높은 사운드,\n직접마주하는 대형 프리미엄 클래스"),
        TheaterModel(logo: "MX4D 로고", card: "MX4D", name: "MX4D", title: "MEGA | MX4D", description: "다이나믹 이펙트가 선사하는\n새로운 영화 체험"),
        TheaterModel(logo: "LED 로고", card: "LED", name: "LED", title: "MEGA | LED", description: "부분대비 명암비, 완벽한 원시 재현력"),
        TheaterModel(logo: "Boutique Private 로고", card: "Boutique Private", name: "Boutique Private", title: "BOUTIQUE PRIVATE by MEGA", description: "오직 나와 소중한 사람들을 위한\n프라이빗한 극장 경험"),
        TheaterModel(logo: "Boutique Suite 로고", card: "Boutique Suite", name: "Boutique Suite", title: "BOUTIQUE SUITE by MEGA", description: "별업 패키지가 더해진\n럭셔리한 공간 경험"),
        TheaterModel(logo: "Boutique 로고", card: "Boutique", name: "Boutique", title: "BOUTIQUE by MEGA", description: "섬세하게 디자인된 감각적인\n극장 경험"),
        TheaterModel(logo: "Le Recliner 로고", card: "Le Recliner", name: "Le Recliner", title: "LE RECLINER by MEGA", description: "편통한 리클라이너 시스템이 구현하는\n극장의 편안함"),
        TheaterModel(logo: "Comfort 로고", card: "Comfort", name: "Comfort", title: "COMFORT by MEGA", description: "안으로 배려와 누리는\n더 편리한 영화 경험"),
    ]
}
