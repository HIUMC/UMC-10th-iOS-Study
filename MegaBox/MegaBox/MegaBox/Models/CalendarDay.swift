//
//  CalendarModel.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//

import Foundation

struct CalendarDay: Identifiable, Hashable {
    var id: Date { Calendar.current.startOfDay(for: date) }
    let day: Int            // 일(day) 숫자
    let date: Date          // 실제 Date
    let weekdaySymbol: String   // "월", "화", ...
    let isToday: Bool
    let isTomorrow: Bool
    let isSunday: Bool
    let isSaturday: Bool

    static func generateWeek(from startDate: Date = Date()) -> [CalendarDay] {
        generateDays(from: (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: startDate)
        })
    }

    static func generateDays(from dates: [Date]) -> [CalendarDay] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"  // "월", "화", ...

        return dates.compactMap { date in
            let day = calendar.component(.day, from: date)
            let weekday = calendar.component(.weekday, from: date) // 1=일, 7=토
            let symbol = formatter.string(from: date)

            return CalendarDay(
                day: day,
                date: date,
                weekdaySymbol: symbol,
                isToday: calendar.isDateInToday(date),
                isTomorrow: calendar.isDateInTomorrow(date),
                isSunday: weekday == 1,
                isSaturday: weekday == 7
            )
        }
    }
}
