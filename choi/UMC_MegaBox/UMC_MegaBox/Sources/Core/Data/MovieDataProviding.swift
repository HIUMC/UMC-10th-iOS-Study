//
//  MovieDataProviding.swift
//  UMC_MegaBox
//

import Foundation

/// 상영시간 생성 결과를 담는 구조체
struct ShowtimeResult {
    let showtimes: [String: [ShowtimeModel]]   // screenName → [ShowtimeModel]
    let emptyTheaters: [String]                 // 상영시간표가 없는 극장 목록
    let noShowtimeMessage: String?
}

/// 영화/극장/상영시간 데이터를 제공하는 프로토콜
/// 향후 API 연동 시 이 프로토콜을 구현하는 새로운 Provider로 교체하면 됨
protocol MovieDataProviding {
    // 홈 화면용
    var homeMovies: [MovieModel] { get }
    var upcomingMovies: [MovieModel] { get }
    var specialTheaters: [TheaterModel] { get }

    // 예매 화면용
    var reservationMovies: [MovieModel] { get }
    var theaterBranches: [String] { get }

    /// 특정 영화의 상영 가능한 날짜 목록 반환
    func availableDates(for movie: MovieModel) -> [CalendarDay]

    /// 선택된 영화 + 극장 + 날짜에 따른 상영시간 생성
    func generateShowtimes(movie: MovieModel?, theaters: Set<String>, date: CalendarDay) -> ShowtimeResult
}
