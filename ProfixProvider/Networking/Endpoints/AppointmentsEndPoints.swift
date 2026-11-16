import Foundation
import Alamofire

struct AppointmentsEndPoints {
    private init() {}

    static func dayPeriods() -> Endpoint<BaseResponse<DayPeriodsResponse>> {
        .init(path: "delegate/day-periods", headerType: .authorized(token: Session.token ?? ""))
    }

    static func toggle(period: DayPeriod, closed: Bool) -> Endpoint<BaseResponse<DayPeriodsResponse>> {
        .init(
            method: .post,
            path: "delegate/day-periods/toggle",
            body: ["from": period.from, "to": period.to, "closed": closed ? 1 : 0],
            headerType: .authorized(token: Session.token ?? ""),
            isMultipart: true
        )
    }
}
