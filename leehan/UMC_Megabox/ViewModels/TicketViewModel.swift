//
//  TicketViewModel.swift
//  leehan
//
//  Created by 이한결 on 4/29/26.
//

import SwiftUI

@Observable
class TicketViewModel {
    // 모든 영화 더미데이터
    var allMovies: [MovieModel] = []
    
    // 모든 극장 더미데이터
    var allTheaters: [TheaterModel] = []
    
    // 모든 스케줄 더미데이터
    var allSchedules: [ScheduleModel] = []
    
    // 사용자가 선택한 영화 데이터
    var selectedMovie: MovieModel? = nil
    
    // 사용자가 선택한 극장 (여러 개 선택 가능)
    var selectedTheaters: [TheaterModel] = []
    
    // 사용자가 선택한 날짜
    var selectedDate: Date? = Date()
    
    // 영화관 선택 여부를 토글하는 함수
    func toggleTheaterSelection(theater: TheaterModel) {
        if let index = selectedTheaters.firstIndex(of: theater) {
            selectedTheaters.remove(at: index)
        } else {
            selectedTheaters.append(theater)
        }
    }
    
    // 현재 보여줘야 하는 영화 스케줄
    // selectedMovie의 id와 selectedTheaters의 id를 ScheduleModel과 매핑
    var groupedSchedules: [TheaterScheduleGroup] {
        // 세 조건 중 선택되어 있지 않은게 있다면 빈배열 반환
        guard let movie = selectedMovie, !selectedTheaters.isEmpty, let date = selectedDate else {
            return []
        }
        
        // 반환할 배열을 빈배열로 초기화
        var resultGroups: [TheaterScheduleGroup] = []
        
        for theater in selectedTheaters {
            let filtered = allSchedules.filter {
                $0.movieId == movie.id &&
                $0.theaterId == theater.id &&
                Calendar.current.isDate($0.date, inSameDayAs: date)
            }
            
            // 만약 걸러낸 스케줄이 없다면 다음 영화관으로
            if filtered.isEmpty { continue }
            
            let groupedByScreen = Dictionary(grouping: filtered, by: { $0.screenName })
            let screenGroups = groupedByScreen.map { (screenName, schedules) in
                let sortedSchedules = schedules.sorted { $0.startTime < $1.startTime }
                return ScreenScheduleGroup(screenName: screenName, schedules: sortedSchedules)
            }
            
            let sortedScreenGroups = screenGroups.sorted { $0.screenName < $1.screenName }
            resultGroups.append(TheaterScheduleGroup(theater: theater, screenGroups: sortedScreenGroups))
        }
        return resultGroups
    }
    
    init() {
        loadDummyData()
    }
    
    private func loadDummyData() {
            let movie1 = MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500, age: "12")
            let movie2 = MovieModel(moviePoster: "movie_humint", movieName: "휴민트", movieViews: 1000, age: "15")
            let movie3 = MovieModel(moviePoster: "movie_hoppers", movieName: "호퍼스", movieViews: 800, age: "ALL")
            let movie4 = MovieModel(moviePoster: "movie_madDance", movieName: "매드댄스", movieViews: 500, age: "15")
            let movie5 = MovieModel(moviePoster: "movie_method", movieName: "메소드연기", movieViews: 300, age: "15")
            let movie6 = MovieModel(moviePoster: "movie_project", movieName: "프로젝트", movieViews: 200, age: "12")
            let movie7 = MovieModel(moviePoster: "movie_years", movieName: "그 해 우리는", movieViews: 100, age: "12")
            
            allMovies = [movie1, movie2, movie3, movie4, movie5, movie6, movie7]
            
            let theater1 = TheaterModel(name: "강남")
            let theater2 = TheaterModel(name: "홍대")
            let theater3 = TheaterModel(name: "신촌")
            
            allTheaters = [theater1, theater2, theater3]
        
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            
                allSchedules = [
                    ScheduleModel(movieId: movie1.id, theaterId: theater1.id, date: today,
                                  startTime: "11:30", endTime: "13:58", screenName: "르 리클라이너 1관", totalSeats: 116, bookedSeats: 109),
                    ScheduleModel(movieId: movie1.id, theaterId: theater1.id, date: today,
                                  startTime: "14:20", endTime: "16:48", screenName: "르 리클라이너 1관", totalSeats: 116, bookedSeats: 19),
                    ScheduleModel(movieId: movie1.id, theaterId: theater1.id, date: today,
                                  startTime: "17:05", endTime: "19:28", screenName: "르 리클라이너 1관", totalSeats: 116, bookedSeats: 1),
                    
                    ScheduleModel(movieId: movie1.id, theaterId: theater2.id, date: today,
                                  startTime: "09:30", endTime: "11:50", screenName: "BTS관 (7층 1관 [Laser])", totalSeats: 116, bookedSeats: 75),
                    ScheduleModel(movieId: movie1.id, theaterId: theater2.id, date: today,
                                  startTime: "12:00", endTime: "14:26", screenName: "BTS관 (7층 1관 [Laser])", totalSeats: 116, bookedSeats: 102),
                    ScheduleModel(movieId: movie1.id, theaterId: theater2.id, date: today,
                                  startTime: "11:30", endTime: "13:58", screenName: "BTS관 (9층 2관 [Laser])", totalSeats: 116, bookedSeats: 34),
                    
                    ScheduleModel(movieId: movie1.id, theaterId: theater3.id, date: today,
                                  startTime: "10:15", endTime: "12:40", screenName: "컴포트 3관", totalSeats: 130, bookedSeats: 50),
                    ScheduleModel(movieId: movie1.id, theaterId: theater3.id, date: today,
                                  startTime: "13:20", endTime: "15:45", screenName: "컴포트 3관", totalSeats: 130, bookedSeats: 128),
                    
                    ScheduleModel(movieId: movie1.id, theaterId: theater1.id, date: tomorrow,
                                  startTime: "08:00", endTime: "10:25", screenName: "조조 특별관", totalSeats: 100, bookedSeats: 5),

                    
                    ScheduleModel(movieId: movie2.id, theaterId: theater1.id, date: today,
                                  startTime: "12:00", endTime: "14:10", screenName: "Dolby Cinema관", totalSeats: 250, bookedSeats: 240),
                    ScheduleModel(movieId: movie2.id, theaterId: theater1.id, date: today,
                                  startTime: "15:30", endTime: "17:40", screenName: "Dolby Cinema관", totalSeats: 250, bookedSeats: 10),
                    
                    ScheduleModel(movieId: movie2.id, theaterId: theater3.id, date: today,
                                  startTime: "18:45", endTime: "20:55", screenName: "일반 1관", totalSeats: 200, bookedSeats: 150),
                    ScheduleModel(movieId: movie2.id, theaterId: theater3.id, date: today,
                                  startTime: "21:30", endTime: "23:40", screenName: "일반 1관", totalSeats: 200, bookedSeats: 190),

                    ScheduleModel(movieId: movie2.id, theaterId: theater2.id, date: tomorrow,
                                  startTime: "14:00", endTime: "16:10", screenName: "일반 4관", totalSeats: 150, bookedSeats: 20),

                    ScheduleModel(movieId: movie3.id, theaterId: theater2.id, date: today,
                                  startTime: "09:00", endTime: "10:45", screenName: "키즈관", totalSeats: 80, bookedSeats: 78),
                    ScheduleModel(movieId: movie3.id, theaterId: theater2.id, date: today,
                                  startTime: "11:15", endTime: "13:00", screenName: "키즈관", totalSeats: 80, bookedSeats: 70),
                    
                    ScheduleModel(movieId: movie3.id, theaterId: theater3.id, date: tomorrow,
                                  startTime: "10:30", endTime: "12:15", screenName: "가족관", totalSeats: 120, bookedSeats: 40),

                    ScheduleModel(movieId: movie4.id, theaterId: theater1.id, date: today,
                                  startTime: "20:00", endTime: "22:15", screenName: "MX4D관", totalSeats: 140, bookedSeats: 60),
                    ScheduleModel(movieId: movie4.id, theaterId: theater1.id, date: today,
                                  startTime: "22:50", endTime: "01:05", screenName: "MX4D관", totalSeats: 140, bookedSeats: 12)
                ]
            
        }
    
}
