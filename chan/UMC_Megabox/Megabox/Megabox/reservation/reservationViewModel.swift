import Foundation
import Combine
import SwiftUI

class ReservationViewModel: ObservableObject {
    // --- 데이터 소스 ---
    @Published var movies: [ReservationModel] = [
        .init(movieImage: Image(.kingsWarden), title: "왕과 사는 남자", rate: 4.8),
        .init(movieImage: Image(.project), title: "프로젝트 헤일메리", rate: 4.6),
        .init(movieImage: Image(.hoppers), title: "호퍼스", rate: 4.1),
        .init(movieImage: Image(.humint), title: "휴민트", rate: 3.8),
        .init(movieImage: Image(.madDance), title: "매드 댄스 오피스", rate: 3.9),
        .init(movieImage: Image(.method), title: "메소드 연기", rate: 4.2),
        .init(movieImage: Image(.years), title: "28년 후", rate: 3.7)
    ]
    
    // 날짜 데이터 (오늘부터 7일간)
    let dates: [Date] = (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: Date()) }

    // --- 선택 상태 ---
    @Published var selectedMovie: ReservationModel? = nil
    @Published var selectedTheater: Theater? = nil
    @Published var selectedDate: Date? = nil
    
    // --- 활성화 상태 (Combine) ---
    @Published var isTheaterEnabled: Bool = false
    @Published var isDateEnabled: Bool = false
    @Published var canShowTimetable: Bool = false
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        // 영화 선택 시 극장 활성화
        $selectedMovie.map { $0 != nil }.assign(to: \.isTheaterEnabled, on: self).store(in: &bag)
        // 영화 + 극장 선택 시 날짜 활성화
        Publishers.CombineLatest($selectedMovie, $selectedTheater)
            .map { $0 != nil && $1 != nil }.assign(to: \.isDateEnabled, on: self).store(in: &bag)
        // 모두 선택 시 시간표 활성화
        Publishers.CombineLatest3($selectedMovie, $selectedTheater, $selectedDate)
            .map { $0 != nil && $1 != nil && $2 != nil }.assign(to: \.canShowTimetable, on: self).store(in: &bag)
        // ReservationViewModel.swift 내부

        func selectMovie(_ movie: ReservationModel) {
            // 1. 이미 선택된 영화를 다시 누르면 선택 해제, 아니면 새로 선택
            if selectedMovie?.id == movie.id {
                selectedMovie = nil
            } else {
                selectedMovie = movie
            }
            
            // 2. [중요] 영화가 바뀌면 하위 선택 항목(극장, 날짜)은 초기화해줘야 함!
            selectedTheater = nil
            selectedDate = nil
        }
    }
}
