import Foundation
import Moya
import Observation // ⭐️ 필수: 새로운 프레임워크 임포트

@Observable // ⭐️ 클래스 위에 이 매크로만 붙이면 끝!
class MovieCardViewModel {
    
    /// 1. 무비차트에 들어갈 영화 배열 chartMovies 와
    /// 2. 상영 예정에 들어갈 영화 배열 upcomingMovies
    ///
    var chartMovies: [MovieModel] = []
    var upcomingMovies: [MovieModel] = []
    var isLoading = false
    var errorMessage: String?

    /// 2. 현재 어떤 차트를 보고 있는지에 대한 상태
    var selectedChart : String = "chartMovies"

    private let provider: MoyaProvider<TMDBTarget>
    private let fallbackMovies: [MovieModel] = [
        MovieModel(id: 1, title: "왕과 사는 남자", posterImage: "kingsWarden", totalAudience: "1191만"),
        MovieModel(id: 2, title: "프로젝트 헤일메리", posterImage: "theBride", totalAudience: "56만"),
        MovieModel(id: 3, title: "호퍼스", posterImage: "hoppers", totalAudience: "191만"),
        MovieModel(id: 4, title: "휴민트", posterImage: "humint", totalAudience: "291만"),
        MovieModel(id: 5, title: "매드 댄스 오피스", posterImage: "madDance", totalAudience: "191만"),
        MovieModel(id: 6, title: "메소드 연기", posterImage: "method", totalAudience: "91만"),
        MovieModel(id: 7, title: "28년 후", posterImage: "years", totalAudience: "41만"),
    ]

    init() {
        self.provider = MoyaProvider<TMDBTarget>()
        self.chartMovies = fallbackMovies
    }

    
    /// 현재 선택된 상태에 맞는 영화 리스트만 골라서 반환
    var currentMovies : [MovieModel] {
        return selectedChart == "chartMovies" ? chartMovies : upcomingMovies
    }

    func fetchNowPlayingMovies() async {
        guard isLoading == false else { return }
        guard Bundle.main.hasValidTMDBAPIKey else {
            errorMessage = "Secret.xcconfig의 TMDB_API_KEY를 실제 키로 교체해주세요."
            chartMovies = fallbackMovies
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await provider
                .requestAsync(.nowPlaying(request: NowPlayingRequestDTO()))
                .filterSuccessfulStatusCodes()
            let decoded = try JSONDecoder().decode(NowPlayingResponseDTO.self, from: response.data)

            chartMovies = decoded.results.map { movie in
                MovieModel(
                    id: movie.id,
                    title: movie.title,
                    originalTitle: movie.originalTitle,
                    overview: movie.overview,
                    releaseDate: movie.releaseDate,
                    posterImage: "kingsWarden",
                    posterURL: imageURL(path: movie.posterPath, size: "w500"),
                    backdropURL: imageURL(path: movie.backdropPath, size: "w780"),
                    totalAudience: "1191만",
                    ageRating: "12"
                )
            }
            upcomingMovies = []
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            chartMovies = fallbackMovies
        }
    }

    private func imageURL(path: String?, size: String) -> URL? {
        guard let path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size)\(path)")
    }
}
