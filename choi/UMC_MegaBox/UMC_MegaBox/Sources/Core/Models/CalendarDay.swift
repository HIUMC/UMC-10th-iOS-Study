import Foundation

struct CalendarDay: Identifiable, Hashable {
    let id = UUID()
    let day: Int            // 일(day) 숫자
    let date: Date          // 실제 Date
    let weekdaySymbol: String   // "월", "화", ...
    let isToday: Bool
    let isTomorrow: Bool
    let isSunday: Bool
    let isSaturday: Bool

    static func generateWeek(from startDate: Date = Date()) -> [CalendarDay] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"  // "월", "화", ...

        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startDate) else {
                return nil
            }

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
