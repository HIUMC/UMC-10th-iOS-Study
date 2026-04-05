import Foundation
import Observation // ⭐️ 필수: 새로운 프레임워크 임포트

@Observable // ⭐️ 클래스 위에 이 매크로만 붙이면 끝!
class MovieCardViewModel {
    
    /// 1. 무비차트에 들어갈 영화 배열 chartMovies 와
    /// 2. 상영 예정에 들어갈 영화 배열 upcomingMovies
    ///
    var chartMovies: [MovieModel] = []
    var upcomingMovies: [MovieModel] = []

    /// 2. 현재 어떤 차트를 보고 있는지에 대한 상태
    var selectedChart : String = "chartMovies"
    init() {
        fetchDummyData()
    }

    
    /// 현재 선택된 상태에 맞는 영화 리스트만 골라서 반환
    var currentMovies : [MovieModel] {
        return selectedChart == "chartMovies" ? chartMovies : upcomingMovies
    }
    private func fetchDummyData() {
        self.chartMovies = [
            MovieModel(title: "왕과 사는 남자", posterImage: "kingsWarden", totalAudience: "1191만"),
            MovieModel(title: "프로젝트 헤일메리", posterImage: "theBride", totalAudience: "56만"),
            MovieModel(title: "호퍼스", posterImage: "hoppers", totalAudience: "191만"),
            MovieModel(title: "휴민트", posterImage: "humint", totalAudience: "291만"),
            MovieModel(title: "매드 댄스 오피스", posterImage: "madDance", totalAudience: "191만"),
            MovieModel(title: "메소드 연기", posterImage: "method", totalAudience: "91만"),
            MovieModel(title: "28년 후", posterImage: "years", totalAudience: "41만"),
        ]
    }
}
