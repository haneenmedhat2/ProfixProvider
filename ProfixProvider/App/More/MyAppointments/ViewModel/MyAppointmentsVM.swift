import Foundation
import Combine

protocol MyAppointmentsVMProtocol {
    var day: DayPeriodsResponse? { get }
    var dayPublisher: Published<DayPeriodsResponse?>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    func getDayPeriods()
    func toggle(period: DayPeriod, closed: Bool)
}

final class MyAppointmentsVM: BaseViewModel, MyAppointmentsVMProtocol {
    @Published private(set) var day: DayPeriodsResponse?
    var dayPublisher: Published<DayPeriodsResponse?>.Publisher { $day }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }

    func getDayPeriods() {
        perform(AppointmentsEndPoints.dayPeriods())
    }

    func toggle(period: DayPeriod, closed: Bool) {
        perform(AppointmentsEndPoints.toggle(period: period, closed: closed))
    }

    private func perform(_ endpoint: Endpoint<BaseResponse<DayPeriodsResponse>>) {
        // Every update returns the whole day; allow only one request at a time.
        guard !isLoading else { return }
        isLoading = true
        Task { @MainActor [weak self] in
            guard let self else { return }
            defer { self.isLoading = false }
            do {
                let response = try await self.getAllRequest(endpoint)
                guard let day = response.data else { throw ResponseError.unableToDecodeResponse }
                self.day = day
            } catch {
                // Keep the last server-confirmed day so the UI can roll back.
                self.error = error
            }
        }
    }
}
