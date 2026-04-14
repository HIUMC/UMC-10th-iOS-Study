import Foundation

@Observable
class HomeViewModel {
    private let dataProvider: MovieDataProviding

    var movies: [MovieModel] { dataProvider.homeMovies }
    var upcomingMovies: [MovieModel] { dataProvider.upcomingMovies }
    let theaters: [TheaterModel]

    // View에서 이동한 UI 상태 (ViewModel이 소유하여 MVVM 준수)
    var selectedSegment: MovieChartType = .nowPlaying
    var selectedTheaterIndex: Int = 0

    // 무비차트 / 상영예정 구분 enum
    enum MovieChartType {
        case nowPlaying
        case upcoming
    }

    init(dataProvider: MovieDataProviding = HardcodedMovieDataProvider()) {
        self.dataProvider = dataProvider
        self.theaters = dataProvider.specialTheaters
    }

    // 선택된 차트 타입에 따라 영화 목록 반환
    func currentMovies(for type: MovieChartType) -> [MovieModel] {
        switch type {
        case .nowPlaying: return movies
        case .upcoming: return upcomingMovies
        }
    }
}
