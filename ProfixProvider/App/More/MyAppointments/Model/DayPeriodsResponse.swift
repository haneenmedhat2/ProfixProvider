import Foundation

struct DayPeriodsResponse: Decodable {
    let date: String
    let closeToday: Bool
    let periods: [DayPeriod]

    enum CodingKeys: String, CodingKey {
        case date, periods
        case closeToday = "close_today"
    }
}

struct DayPeriod: Decodable {
    let from: String
    let to: String
    let label: String
    let isClosed: Bool
    let isOpen: Bool

    enum CodingKeys: String, CodingKey {
        case from, to, label
        case isClosed = "is_closed"
        case isOpen = "is_open"
    }
}
