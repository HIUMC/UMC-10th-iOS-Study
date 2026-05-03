//
//  JSONMovieDataProvider.swift
//  UMC_MegaBox
//
//  로컬 JSON 파일에서 영화 상영 정보를 비동기로 로드하는 Provider
//

import Foundation

struct JSONMovieDataProvider: MovieDataProviding {

    // MARK: - 내부 저장 (JSON에서 파싱된 원본 DTO)

    private(set) var movieDTOs: [MovieScheduleMovieDTO]

    // MARK: - Init

    /// 빈 상태로 초기화 (비동기 로드 전)
    init() {
        self.movieDTOs = []
    }

    /// DTO 배열을 직접 주입하여 초기화 (비동기 로드 후 사용)
    private init(movieDTOs: [MovieScheduleMovieDTO]) {
        self.movieDTOs = movieDTOs
    }

    // MARK: - 비동기 팩토리 메서드

    /// Bundle에서 MovieSchedule.json을 비동기로 로드하고, 데이터가 채워진 Provider를 반환
    static func load() async -> JSONMovieDataProvider {
        let dtos = await loadMovieScheduleAsync()
        return JSONMovieDataProvider(movieDTOs: dtos)
    }

    // MARK: - 비동기 JSON 로드 & 디코딩

    /// Bundle에서 MovieSchedule.json을 비동기로 로드하고 디코딩
    private static func loadMovieScheduleAsync() async -> [MovieScheduleMovieDTO] {
        // 백그라운드 스레드에서 파일 I/O + 디코딩 수행
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let result = performLoad()
                continuation.resume(returning: result)
            }
        }
    }

    /// 실제 파일 로드 & 디코딩 수행 (동기)
    private static func performLoad() -> [MovieScheduleMovieDTO] {
        // 1. 파일 URL 확인
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            print("[JSONMovieDataProvider] MovieSchedule.json 파일을 찾을 수 없습니다.")
            return []
        }

        do {
            // 2. Data 로드
            let data = try Data(contentsOf: url)

            // 3. JSON 디코딩
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieScheduleResponseDTO.self, from: data)

            print("[JSONMovieDataProvider] JSON 로드 성공 - 영화 \(response.data.movies.count)개")
            return response.data.movies

        } catch let DecodingError.keyNotFound(key, context) {
            print("[JSONMovieDataProvider] 디코딩 에러 - 키 '\(key.stringValue)' 없음: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("[JSONMovieDataProvider] 디코딩 에러 - 타입 불일치 '\(type)': \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            print("[JSONMovieDataProvider] 디코딩 에러 - 값 없음 '\(type)': \(context.debugDescription)")
        } catch let DecodingError.dataCorrupted(context) {
            print("[JSONMovieDataProvider] 디코딩 에러 - 데이터 손상: \(context.debugDescription)")
        } catch {
            print("[JSONMovieDataProvider] JSON 로드 실패: \(error.localizedDescription)")
        }

        return []
    }

    // MARK: - 홈 화면 데이터 (JSON에는 홈 데이터 없음 → 빈 배열)

    var homeMovies: [MovieModel] { [] }
    var upcomingMovies: [MovieModel] { [] }
    var specialTheaters: [TheaterModel] { [] }

    // MARK: - 예매 화면 데이터

    /// JSON의 영화 목록을 도메인 모델로 변환
    var reservationMovies: [MovieModel] {
        movieDTOs.map { $0.toDomain() }
    }

    /// JSON 전체에서 등장하는 모든 지역(area)을 순서 유지하며 추출
    var theaterBranches: [String] {
        var seen = Set<String>()
        var branches: [String] = []

        for movie in movieDTOs {
            for schedule in movie.schedules {
                for area in schedule.areas {
                    if !seen.contains(area.area) {
                        seen.insert(area.area)
                        branches.append(area.area)
                    }
                }
            }
        }
        return branches
    }

    // MARK: - 특정 영화의 상영 가능 날짜

    func availableDates(for movie: MovieModel) -> [CalendarDay] {
        guard let dto = findMovieDTO(for: movie) else { return [] }

        return dto.schedules.compactMap { schedule in
            schedule.toCalendarDay()
        }
    }

    // MARK: - 상영시간 생성

    func generateShowtimes(movie: MovieModel?, theaters: Set<String>, date: CalendarDay) -> ShowtimeResult {
        guard let movie,
              let dto = findMovieDTO(for: movie) else {
            return ShowtimeResult(
                showtimes: [:],
                emptyTheaters: [],
                noShowtimeMessage: "영화를 선택해주세요"
            )
        }

        // 1. 선택된 날짜와 매칭되는 ScheduleDTO 찾기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let selectedDateString = dateFormatter.string(from: date.date)

        guard let schedule = dto.schedules.first(where: { $0.date == selectedDateString }) else {
            return ShowtimeResult(
                showtimes: [:],
                emptyTheaters: [],
                noShowtimeMessage: "선택한 날짜에 상영시간표가 없습니다"
            )
        }

        // 2. 선택된 극장(area)별로 상영시간 구성
        var merged: [String: [ShowtimeModel]] = [:]
        var emptyBranches: [String] = []

        // theaterBranches 순서대로 순회 (정렬 유지)
        for branch in theaterBranches where theaters.contains(branch) {
            if let areaDTO = schedule.areas.first(where: { $0.area == branch }) {
                // 해당 지역에 상영관 데이터가 있음
                for item in areaDTO.items {
                    let showtimeModels = item.showtimes.map { showtimeDTO in
                        showtimeDTO.toDomain(
                            theaterBranch: branch,
                            screenName: item.auditorium,
                            format: item.format
                        )
                    }
                    merged[item.auditorium] = showtimeModels
                }
            } else {
                // 해당 지역에 상영 데이터 없음 → Empty State
                emptyBranches.append(branch)
            }
        }

        let message: String? = (merged.isEmpty && !emptyBranches.isEmpty)
            ? "선택한 극장에 상영시간표가 없습니다"
            : nil

        return ShowtimeResult(
            showtimes: merged,
            emptyTheaters: emptyBranches,
            noShowtimeMessage: message
        )
    }

    // MARK: - Private Helpers

    /// MovieModel의 title로 대응하는 DTO 찾기
    private func findMovieDTO(for movie: MovieModel) -> MovieScheduleMovieDTO? {
        movieDTOs.first { $0.title == movie.title }
    }
}
