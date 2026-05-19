import Foundation

struct ReservationResponseModel: Hashable {
    let status: String
    let message: String
    let data: ReservationDataModel
}

struct ReservationDataModel: Hashable {
    let movies: [ReservationMovieModel]
}

struct ReservationMovieModel: Identifiable, Hashable {
    let id: String
    let title: String
    let ageRating: String
    let schedules: [ReservationScheduleModel]
}

struct ReservationScheduleModel: Identifiable, Hashable {
    let date: Date
    let areas: [ReservationAreaModel]

    var id: Date {
        Calendar.current.startOfDay(for: date)
    }
}

struct ReservationAreaModel: Identifiable, Hashable {
    let area: String
    let items: [ReservationAuditoriumModel]

    var id: String { area }
}

struct ReservationAuditoriumModel: Identifiable, Hashable {
    let auditorium: String
    let format: String
    let showtimes: [ReservationShowtimeModel]

    var id: String { "\(auditorium)-\(format)" }
}

struct ReservationShowtimeModel: Identifiable, Hashable {
    let start: String
    let end: String
    let available: Int
    let total: Int

    var id: String { "\(start)-\(end)" }
}
