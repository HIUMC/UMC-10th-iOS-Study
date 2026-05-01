//
//  MovieScheduleMapper.swift
//  UMC_MegaBox
//
//  DTO → Domain Model 변환 Mapper
//

import Foundation

// MARK: - MovieScheduleMovieDTO → MovieModel

extension MovieScheduleMovieDTO {
    /// DTO의 age_rating("15", "12", "All") → 도메인 rating 문자열로 변환
    func toDomain() -> MovieModel {
        let ratingString: String = {
            switch ageRating {
            case "All":  return "전체 관람가"
            case "12":   return "12세 이상 관람가"
            case "15":   return "15세 이상 관람가"
            case "19":   return "청소년 관람불가"
            default:     return ageRating
            }
        }()

        return MovieModel(
            title: title,
            posterImage: "",           // JSON에는 포스터 정보 없음
            audienceCount: 0,
            englishTitle: "",
            quote: "",
            description: "",
            rating: ratingString,
            releaseInfo: "",
            genre: "",
            type: "",
            director: "",
            cast: ""
        )
    }
}

// MARK: - ShowtimeItemDTO → ShowtimeModel

extension ShowtimeItemDTO {
    /// 상영시간 DTO → 도메인 ShowtimeModel로 변환
    func toDomain(theaterBranch: String, screenName: String, format: String) -> ShowtimeModel {
        ShowtimeModel(
            theaterBranch: theaterBranch,
            screenName: screenName,
            format: format,
            time: start,
            endTime: "~\(end)",
            totalSeats: total,
            remainingSeats: available
        )
    }
}

// MARK: - ScheduleDTO → CalendarDay

extension ScheduleDTO {
    /// 날짜 문자열 "2025-09-22" → CalendarDay 변환
    func toCalendarDay() -> CalendarDay? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")

        guard let date = formatter.date(from: self.date) else { return nil }

        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date) // 1=일, 7=토

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "ko_KR")
        weekdayFormatter.dateFormat = "E"

        return CalendarDay(
            day: day,
            date: date,
            weekdaySymbol: weekdayFormatter.string(from: date),
            isToday: calendar.isDateInToday(date),
            isTomorrow: calendar.isDateInTomorrow(date),
            isSunday: weekday == 1,
            isSaturday: weekday == 7
        )
    }
}
