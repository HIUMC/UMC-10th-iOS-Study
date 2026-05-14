import Foundation

@Observable
class HomeViewModel {
    private let movieService: TMDBMovieServicing

    var movies: [MovieModel]
    var upcomingMovies: [MovieModel]
    let theaters: [TheaterModel]

    var isLoadingMovies = false
    var movieLoadingError: String?

    // View에서 이동한 UI 상태 (ViewModel이 소유하여 MVVM 준수)
    var selectedSegment: MovieChartType = .nowPlaying
    var selectedTheaterIndex: Int = 0

    // 무비차트 / 상영예정 구분 enum
    enum MovieChartType {
        case nowPlaying
        case upcoming
    }

    init(
        dataProvider: MovieDataProviding = HardcodedMovieDataProvider(),
        movieService: TMDBMovieServicing = TMDBMovieService()
    ) {
        self.movieService = movieService
        self.movies = dataProvider.homeMovies
        self.upcomingMovies = dataProvider.upcomingMovies
        self.theaters = dataProvider.specialTheaters
    }

    @MainActor
    func loadNowPlayingMovies() async {
        guard !isLoadingMovies else { return }

        isLoadingMovies = true
        movieLoadingError = nil
        defer { isLoadingMovies = false }

        do {
            let response = try await movieService.fetchNowPlaying(request: .init())
            let mappedMovies = response.results.map { movie in
                movie.toMovieModel(audienceCount: 100)
            }

            if !mappedMovies.isEmpty {
                movies = mappedMovies
            }
        } catch {
            movieLoadingError = error.localizedDescription
            print("[HomeViewModel] TMDB Now Playing 로드 실패:", error.localizedDescription)
        }
    }

    // 선택된 차트 타입에 따라 영화 목록 반환
    func currentMovies(for type: MovieChartType) -> [MovieModel] {
        switch type {
        case .nowPlaying: return movies
        case .upcoming: return upcomingMovies
        }
    }
}
