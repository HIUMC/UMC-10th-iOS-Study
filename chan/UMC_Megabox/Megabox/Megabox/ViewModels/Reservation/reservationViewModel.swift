import Foundation
import Combine
import SwiftUI

class ReservationViewModel: ObservableObject {
    // --- 데이터 소스 ---
    @Published var movies: [ReservationModel] = [
        .init(posterName: "kingsWarden", title: "왕과 사는 남자", rate: 4.8),
        .init(posterName: "project", title: "프로젝트 헤일메리", rate: 4.6),
        .init(posterName: "hoppers", title: "호퍼스", rate: 4.1),
        .init(posterName: "humint", title: "휴민트", rate: 3.8),
        .init(posterName: "madDance", title: "매드 댄스 오피스", rate: 3.9),
        .init(posterName: "method", title: "메소드 연기", rate: 4.2),
        .init(posterName: "years", title: "28년 후", rate: 3.7)
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
    
    // --- JSON 데이터 저장소 ---
    @Published var movieDataDTO: [MovieInfoDTO] = []
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        // 1. [5주차] 데이터 로드 시작
        fetchMovieSchedules()
        
        // 2. [4주차] Combine 파이프라인 설정
        setupPipelines()
    }
    
    // --- 기능 함수들 ---
    
    private func setupPipelines() {
        // 영화 선택 시 극장 활성화
        $selectedMovie
            .map { $0 != nil }
            .assign(to: \.isTheaterEnabled, on: self)
            .store(in: &bag)
            
        // 영화 + 극장 선택 시 날짜 활성화
        Publishers.CombineLatest($selectedMovie, $selectedTheater)
            .map { $0 != nil && $1 != nil }
            .assign(to: \.isDateEnabled, on: self)
            .store(in: &bag)
            
        // 모두 선택 시 시간표 노출
        Publishers.CombineLatest3($selectedMovie, $selectedTheater, $selectedDate)
            .map { $0 != nil && $1 != nil && $2 != nil }
            .assign(to: \.canShowTimetable, on: self)
            .store(in: &bag)
    }

    func fetchMovieSchedules() {
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else { return }

        // Task를 사용하면 Swift가 알아서 스레드 안전성을 관리합니다.
        Task {
            do {
                // 백그라운드에서 데이터 로드 (메인 스레드 차단 방지)
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(MovieResponseDTO.self, from: data)
                
                // UI 업데이트는 자동으로 메인 액터에서 실행됨 (ViewModel이 @MainActor이거나 ObservableObject이므로)
                self.movieDataDTO = response.data.movies
                print("✅ 데이터 로드 성공!")
            } catch {
                print("❌ 디코딩 에러: \(error)")
            }
        }
    }
    // 영화 선택 처리 함수 (초기화 로직 포함)
    func selectMovie(_ movie: ReservationModel) {
        if selectedMovie?.id == movie.id {
            selectedMovie = nil
        } else {
            selectedMovie = movie
        }
        
        // 영화가 바뀌면 하위 선택지는 초기화
        selectedTheater = nil
        selectedDate = nil
    }

    func selectTheater(_ theater: Theater) {
        guard isTheaterEnabled else { return }
        selectedTheater = selectedTheater == theater ? nil : theater
        selectedDate = nil
    }

    func selectDate(_ date: Date) {
        guard isDateEnabled else { return }
        selectedDate = date
    }

    // 필터링된 상영 정보 (뷰에서 사용)
    var filteredSchedules: [AuditoriumItemDTO] {
        guard selectedMovie != nil,
              let selectedTheater = selectedTheater,
              let selectedDate = selectedDate else { return [] }

        guard Calendar.current.isDate(selectedDate, inSameDayAs: dates[0]),
              selectedTheater != .sinchon else { return [] }
        
        let dailySchedule = movieDataDTO.first?.schedules.first
        let areaInfo = dailySchedule?.areas.first { $0.area == selectedTheater.rawValue }
        
        return areaInfo?.items ?? []
    }
}
