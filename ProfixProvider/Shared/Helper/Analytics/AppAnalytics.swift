import Foundation
import AppsFlyerLib

enum AnalyticsEvent {
    static let loginSuccess = "login_success"
    static let serviceAdded = "service_added"
    static let orderAccepted = "order_accepted"
    static let orderFinished = "order_finished"
}

enum AnalyticsParameter {
    static let orderId = "order_id"
}

enum AnalyticsDebug {
    nonisolated static func log(_ message: @autoclosure () -> String) {
        #if DEBUG
        print("[AppsFlyer][Provider] \(message())")
        #endif
    }
}

protocol OrderAnalyticsTracking {
    func orderAccepted(orderId: Int)
    func orderFinished(orderId: Int)
}

protocol LoginAnalyticsTracking {
    func login()
}

protocol ServiceAnalyticsTracking {
    func serviceAdded()
}

final class AppAnalytics: OrderAnalyticsTracking, LoginAnalyticsTracking, ServiceAnalyticsTracking {
    static let shared = AppAnalytics()

    private var isConfigured = false

    private init() {}

    func configure() {
        guard !isConfigured else {
            AnalyticsDebug.log("Configuration skipped: SDK is already configured.")
            return
        }
        guard let devKey = Bundle.main.object(forInfoDictionaryKey: "AppsFlyerDevKey") as? String,
              !devKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !devKey.contains("$(") else {
            AnalyticsDebug.log("Configuration failed: set APPSFLYER_DEV_KEY in the target's build settings.")
            return
        }
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "AppsFlyerAppID") as? String,
              !appID.isEmpty else {
            AnalyticsDebug.log("Configuration failed: AppsFlyerAppID is missing from Info.plist.")
            return
        }

        let sdk = AppsFlyerLib.shared()
        #if DEBUG
        sdk.isDebug = true
        #endif
        sdk.appsFlyerDevKey = devKey
        sdk.appleAppID = appID
        isConfigured = true
        AnalyticsDebug.log("Configured SDK; app_id=\(appID), dev_key=present.")
    }

    func start() {
        guard isConfigured else {
            AnalyticsDebug.log("SDK start skipped: analytics is not configured.")
            return
        }
        #if DEBUG
        AnalyticsDebug.log("Starting SDK for active scene.")
        AppsFlyerLib.shared().start(completionHandler: { _, error in
            if let error {
                let sdkError = error as NSError
                AnalyticsDebug.log("SDK start failed; domain=\(sdkError.domain), code=\(sdkError.code).")
            } else {
                AnalyticsDebug.log("SDK start callback completed successfully.")
            }
        })
        #else
        AppsFlyerLib.shared().start()
        #endif
    }

    func login() {
        logEvent(AnalyticsEvent.loginSuccess, values: [:])
    }

    func serviceAdded() {
        logEvent(AnalyticsEvent.serviceAdded, values: [:])
    }

    func orderAccepted(orderId: Int) {
        logEvent(AnalyticsEvent.orderAccepted, values: [AnalyticsParameter.orderId: orderId])
    }

    func orderFinished(orderId: Int) {
        logEvent(AnalyticsEvent.orderFinished, values: [AnalyticsParameter.orderId: orderId])
    }

    private func logEvent(_ name: String, values: [String: Any]) {
        guard isConfigured else {
            AnalyticsDebug.log("Skipped \(name); reason=analytics is not configured.")
            return
        }
        #if DEBUG
        AnalyticsDebug.log("Submitting \(name); values=\(values).")
        AppsFlyerLib.shared().logEvent(
            name: name,
            values: values
        ) { _, error in
            if let error {
                let sdkError = error as NSError
                AnalyticsDebug.log("\(name) submission failed; domain=\(sdkError.domain), code=\(sdkError.code).")
            } else {
                AnalyticsDebug.log("\(name) submission callback completed successfully.")
            }
        }
        #else
        AppsFlyerLib.shared().logEvent(
            name,
            withValues: values
        )
        #endif
    }
}
