import Foundation

struct ReservationResponseDTO: Decodable {
    let status: String?
    let message: String?
    let data: ReservationDataDTO?
}

struct ReservationDataDTO: Decodable {
    let movies: [ReservationMovieDTO]?
}

struct ReservationMovieDTO: Decodable {
    let id: String?
    let title: String?
    let ageRating: String?
    let schedules: [ReservationScheduleDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case ageRating = "age_rating"
        case schedules
    }
}

struct ReservationScheduleDTO: Decodable {
    let date: String?
    let areas: [ReservationAreaDTO]?
}

struct ReservationAreaDTO: Decodable {
    let area: String?
    let items: [ReservationAuditoriumDTO]?
}

struct ReservationAuditoriumDTO: Decodable {
    let auditorium: String?
    let format: String?
    let showtimes: [ReservationShowtimeDTO]?
}

struct ReservationShowtimeDTO: Decodable {
    let start: String?
    let end: String?
    let available: Int?
    let total: Int?
}

extension ReservationResponseDTO {
    func toDomain() -> ReservationResponseModel? {
        guard
            let status,
            let message,
            let data = data?.toDomain()
        else {
            return nil
        }

        return ReservationResponseModel(
            status: status,
            message: message,
            data: data
        )
    }
}

extension ReservationDataDTO {
    func toDomain() -> ReservationDataModel? {
        guard let movies else {
            return nil
        }

        return ReservationDataModel(
            movies: movies.compactMap { $0.toDomain() }
        )
    }
}

extension ReservationMovieDTO {
    func toDomain() -> ReservationMovieModel? {
        guard
            let id,
            let title,
            let ageRating
        else {
            return nil
        }

        return ReservationMovieModel(
            id: id,
            title: title,
            ageRating: ageRating,
            schedules: (schedules ?? []).compactMap { $0.toDomain() }
        )
    }
}

extension ReservationScheduleDTO {
    func toDomain() -> ReservationScheduleModel? {
        guard
            let date,
            let parsedDate = ReservationDateMapper.scheduleDate(from: date)
        else {
            return nil
        }

        return ReservationScheduleModel(
            date: parsedDate,
            areas: (areas ?? []).compactMap { $0.toDomain() }
        )
    }
}

extension ReservationAreaDTO {
    func toDomain() -> ReservationAreaModel? {
        guard let area else {
            return nil
        }

        return ReservationAreaModel(
            area: area,
            items: (items ?? []).compactMap { $0.toDomain() }
        )
    }
}

extension ReservationAuditoriumDTO {
    func toDomain() -> ReservationAuditoriumModel? {
        guard
            let auditorium,
            let format
        else {
            return nil
        }

        return ReservationAuditoriumModel(
            auditorium: auditorium,
            format: format,
            showtimes: (showtimes ?? []).compactMap { $0.toDomain() }
        )
    }
}

extension ReservationShowtimeDTO {
    func toDomain() -> ReservationShowtimeModel? {
        guard
            let start,
            let end,
            let available,
            let total
        else {
            return nil
        }

        return ReservationShowtimeModel(
            start: start,
            end: end,
            available: available,
            total: total
        )
    }
}

private enum ReservationDateMapper {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func scheduleDate(from value: String) -> Date? {
        formatter.date(from: value)
    }
}
