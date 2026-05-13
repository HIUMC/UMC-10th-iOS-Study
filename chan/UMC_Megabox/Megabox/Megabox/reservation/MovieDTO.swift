// MovieDTO.swift
import Foundation

// 1. 전체 응답 DTO
struct MovieResponseDTO: Codable {
    let status: String
    let message: String
    let data: MovieDataDTO
}

// 2. data 필드 DTO
struct MovieDataDTO: Codable {
    let movies: [MovieInfoDTO]
}

// 3. 영화 정보 DTO (id, title, schedules 등)
struct MovieInfoDTO: Codable {
    let id: String
    let title: String
    let age_rating: String
    let schedules: [ScheduleDTO]
}

// 4. 상영 정보 및 하위 DTO들
struct ScheduleDTO: Codable {
    let date: String
    let areas: [AreaDTO]
}

struct AreaDTO: Codable {
    let area: String
    let items: [AuditoriumItemDTO]
}

struct AuditoriumItemDTO: Codable {
    let auditorium: String
    let format: String
    let showtimes: [ShowtimeDTO]
}

struct ShowtimeDTO: Codable {
    let start: String
    let end: String
    let available: Int
    let total: Int
}


extension ShowtimeDTO {
    // 예: "11:30" 시작 시간만 반환하거나 "11:30 ~ 13:30" 형태로 가공
    func toFullTimeString() -> String {
        return "\(start) ~ \(end)"
    }
}

// 2. 상영관 정보 DTO 확장
extension AuditoriumItemDTO {
    // 뷰에서 ID가 필요할 때 사용할 수 있도록 고유값 생성 (ForEach용)
    var id: String {
        return "\(auditorium)-\(format)"
    }
}

// 3. 날짜 처리 Mapper (DateFormatter 활용)
extension ScheduleDTO {
    // JSON의 "2024-09-22" 문자열을 앱 내 Date 객체와 비교하기 좋게 변환할 때 참고
    func isSameDate(with targetDate: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return self.date == formatter.string(from: targetDate)
    }
}
