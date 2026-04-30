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
        // JSON 파일 경로 확인
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            print("❌ JSON 파일을 찾을 수 없습니다. Xcode 프로젝트에 추가했는지 확인하세요.")
            return
        }

        // 비동기 데이터 로드
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponseDTO.self, from: data)
                
                DispatchQueue.main.async {
                    self.movieDataDTO = response.data.movies
                    print("✅ 5주차 데이터 로드 및 디코딩 성공!")
                }
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

    // 필터링된 상영 정보 (뷰에서 사용)
    var filteredSchedules: [AuditoriumItemDTO] {
        guard let selectedMovie = selectedMovie,
              let selectedTheater = selectedTheater,
              let selectedDate = selectedDate else { return [] }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        
        // 제목, 날짜, 지역 순으로 필터링
        let movieInfo = movieDataDTO.first { $0.title == selectedMovie.title }
        let dailySchedule = movieInfo?.schedules.first { $0.date == dateString }
        let areaInfo = dailySchedule?.areas.first { $0.area == selectedTheater.rawValue }
        
        return areaInfo?.items ?? []
    }
}
