import XCTest
@testable import ProfixProvider

@MainActor
final class LoginAndOrderAcceptanceAnalyticsTests: XCTestCase {
    func testLoginTracksOnlySuccessfulAuthentication() async throws {
        let handler = EventResponseHandler()
        let analytics = EventAnalyticsSpy()
        let model = LoginVM(responseHandler: handler, analytics: analytics)

        handler.key = .needApprove
        model.loginRequest(model: LoginModel(phone: "123456789", password: "password"))
        try await waitUntilIdle { model.isLoading }
        XCTAssertEqual(analytics.loginCount, 0)

        handler.key = .success
        model.loginRequest(model: LoginModel(phone: "123456789", password: "password"))
        try await waitUntilIdle { model.isLoading }
        XCTAssertEqual(analytics.loginCount, 1)
        XCTAssertEqual(handler.paths, ["login", "login"])
    }

    func testAcceptOrderTracksOnceAfterSuccessAndAllowsRetryAfterFailure() async throws {
        let handler = EventResponseHandler()
        let analytics = EventAnalyticsSpy()
        let model = OrderDetailsVM(orderId: 42, responseHandler: handler, analytics: analytics)

        handler.key = .needApprove
        model.acceptOrderRequest()
        try await waitUntilIdle { model.isLoading }
        XCTAssertTrue(analytics.acceptedOrderIDs.isEmpty)
        XCTAssertNil(model.acceptOrder)

        handler.key = .success
        model.acceptOrderRequest()
        model.acceptOrderRequest()
        try await waitUntilIdle { model.isLoading }
        model.acceptOrderRequest()
        XCTAssertEqual(handler.paths, ["delegate-accept-order", "delegate-accept-order"])
        XCTAssertEqual(handler.orderIDs, [42, 42])
        XCTAssertEqual(analytics.acceptedOrderIDs, [42])
        XCTAssertEqual(model.acceptOrder?.key, .success)
    }

    private func waitUntilIdle(_ isLoading: () -> Bool) async throws {
        for _ in 0..<200 {
            if !isLoading() { return }
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        XCTFail("Request did not complete")
    }
}

private final class EventAnalyticsSpy: LoginAnalyticsTracking, OrderAnalyticsTracking {
    var loginCount = 0
    var acceptedOrderIDs: [Int] = []

    func login() { loginCount += 1 }
    func orderAccepted(orderId: Int) { acceptedOrderIDs.append(orderId) }
    func orderFinished(orderId: Int) {}
}

private final class EventResponseHandler: ResponseHandler {
    var key: ServerResponseKey = .success
    var paths: [String] = []
    var orderIDs: [Int] = []

    func get<T: Decodable>(_ endpoint: Endpoint<T>, progress: ((Int) -> Void)?) async throws -> T {
        paths.append(endpoint.path)
        if let orderID = endpoint.body?["order_id"] as? Int {
            orderIDs.append(orderID)
        }
        let payload: [String: Any] = [
            "key": key.rawValue,
            "msg": "Test response",
            "data": endpoint.path == "login"
                ? ["token": "test-token", "user": ["id": 7, "completed_info": true]] as Any
                : "" as Any
        ]
        return try JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: payload))
    }
}
