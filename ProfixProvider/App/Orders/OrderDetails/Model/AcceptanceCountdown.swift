import Foundation

/// The API duration is authoritative; elapsed uptime only drives the local display.
struct AcceptanceCountdown {
    private let deadline: TimeInterval

    init?(seconds: Int?, now: TimeInterval = ProcessInfo.processInfo.systemUptime) {
        guard let seconds, seconds > 0 else { return nil }
        deadline = now + TimeInterval(seconds)
    }

    func remainingSeconds(now: TimeInterval = ProcessInfo.processInfo.systemUptime) -> Int {
        max(0, Int(ceil(deadline - now)))
    }

    static func clock(seconds: Int) -> String {
        let value = max(0, seconds)
        return String(format: "%02d:%02d:%02d", value / 3600, (value % 3600) / 60, value % 60)
    }
}
