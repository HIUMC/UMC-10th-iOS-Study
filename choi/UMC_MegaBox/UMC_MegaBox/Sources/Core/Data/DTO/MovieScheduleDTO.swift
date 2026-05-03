//
//  MovieScheduleDTO.swift
//  UMC_MegaBox
//
//  JSON 응답 구조를 1:1 매핑하는 DTO (Data Transfer Object)
//

import Foundation

// MARK: - 최상위 응답

struct MovieScheduleResponseDTO: Codable {
    let status: String
    let message: String
    let data: MovieScheduleDataDTO
}

// MARK: - data

struct MovieScheduleDataDTO: Codable {
    let movies: [MovieScheduleMovieDTO]
}

// MARK: - movies 배열 내 영화 정보

struct MovieScheduleMovieDTO: Codable {
    let id: String
    let title: String
    let ageRating: String
    let schedules: [ScheduleDTO]

    enum CodingKeys: String, CodingKey {
        case id, title, schedules
        case ageRating = "age_rating"
    }
}

// MARK: - 날짜별 상영 일정

struct ScheduleDTO: Codable {
    let date: String          // "2025-09-22"
    let areas: [AreaDTO]
}

// MARK: - 지역 정보

struct AreaDTO: Codable {
    let area: String          // "강남", "홍대"
    let items: [AuditoriumItemDTO]
}

// MARK: - 상영관 정보

struct AuditoriumItemDTO: Codable {
    let auditorium: String    // "크리클라이너 1관"
    let format: String        // "2D", "IMAX", "4DX"
    let showtimes: [ShowtimeItemDTO]
}

// MARK: - 개별 상영 시간

struct ShowtimeItemDTO: Codable {
    let start: String         // "11:30"
    let end: String           // "13:58"
    let available: Int        // 잔여석
    let total: Int            // 총 좌석수
}
