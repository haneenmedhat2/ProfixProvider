import XCTest
@testable import ProfixProvider

@MainActor
final class OrderFinishAnalyticsTests: XCTestCase {
    func testLogsOnlyAfterSuccessfulResponseWithMatchingOrderID() async throws {
        let handler = StubResponseHandler()
        handler.delay = 50_000_000
        let analytics = AnalyticsSpy()
        let model = OrderDetailsVM(orderId: 125, responseHandler: handler, analytics: analytics)

        model.finsihOrderRequest(code: "1234")
        XCTAssertTrue(analytics.orderIDs.isEmpty)
        try await waitForRequest(model)

        XCTAssertEqual(handler.paths, ["delegate-finish-order"])
        XCTAssertEqual(handler.orderIDs, [125])
        XCTAssertEqual(handler.codes, ["1234"])
        XCTAssertEqual(analytics.orderIDs, [125])
        XCTAssertEqual(model.finishOrder?.key, .success)
    }

    func testInvalidCodeAllowsRetryAndLogsOnlyTheSuccessfulAttempt() async throws {
        let handler = StubResponseHandler()
        handler.key = .fail
        let analytics = AnalyticsSpy()
        let model = OrderDetailsVM(orderId: 126, responseHandler: handler, analytics: analytics)

        model.finsihOrderRequest(code: "0000")
        try await waitForRequest(model)
        XCTAssertTrue(analytics.orderIDs.isEmpty)
        XCTAssertNil(model.finishOrder)
        XCTAssertNotNil(model.error)

        handler.key = .success
        model.finsihOrderRequest(code: "1234")
        try await waitForRequest(model)
        XCTAssertEqual(handler.codes, ["0000", "1234"])
        XCTAssertEqual(analytics.orderIDs, [126])
    }

    func testNonSuccessResponsesNeverLogOrPublishCompletion() async throws {
        // These keys can pass through BaseViewModel without throwing.
        for key: ServerResponseKey in [.needApproval, .needApprove, .refused] {
            let handler = StubResponseHandler()
            handler.key = key
            let analytics = AnalyticsSpy()
            let model = OrderDetailsVM(orderId: 127, responseHandler: handler, analytics: analytics)

            model.finsihOrderRequest(code: "1234")
            try await waitForRequest(model)
            XCTAssertTrue(analytics.orderIDs.isEmpty, key.rawValue)
            XCTAssertNil(model.finishOrder, key.rawValue)
            XCTAssertNotNil(model.error, key.rawValue)
        }
    }

    func testNetworkFailureAndCancellationNeverLog() async throws {
        for error: Error in [URLError(.notConnectedToInternet), CancellationError()] {
            let handler = StubResponseHandler()
            handler.failure = error
            let analytics = AnalyticsSpy()
            let model = OrderDetailsVM(orderId: 128, responseHandler: handler, analytics: analytics)

            model.finsihOrderRequest(code: "1234")
            try await waitForRequest(model)
            XCTAssertTrue(analytics.orderIDs.isEmpty)
            XCTAssertNil(model.finishOrder)
        }
    }

    func testRepeatedSubmissionsProduceOneRequestAndOneEvent() async throws {
        let handler = StubResponseHandler()
        handler.delay = 50_000_000
        let analytics = AnalyticsSpy()
        let model = OrderDetailsVM(orderId: 129, responseHandler: handler, analytics: analytics)

        model.finsihOrderRequest(code: "1234")
        model.finsihOrderRequest(code: "1234")
        try await waitForRequest(model)
        model.finsihOrderRequest(code: "1234")
        XCTAssertFalse(model.isLoading)
        XCTAssertEqual(handler.paths.count, 1)
        XCTAssertEqual(analytics.orderIDs, [129])
    }

    private func waitForRequest(_ model: OrderDetailsVM) async throws {
        for _ in 0..<200 {
            if !model.isLoading { return }
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        XCTFail("Finish request did not complete")
    }
}

private final class AnalyticsSpy: OrderAnalyticsTracking {
    var orderIDs: [Int] = []

    func orderAccepted(orderId: Int) {}

    func orderFinished(orderId: Int) {
        orderIDs.append(orderId)
    }
}

private final class StubResponseHandler: ResponseHandler {
    var key: ServerResponseKey = .success
    var failure: Error?
    var delay: UInt64 = 0
    var paths: [String] = []
    var orderIDs: [Int] = []
    var codes: [String] = []

    func get<T: Decodable>(_ endpoint: Endpoint<T>, progress: ((Int) -> Void)?) async throws -> T {
        paths.append(endpoint.path)
        orderIDs.append(endpoint.body?["order_id"] as! Int)
        codes.append(endpoint.body?["code"] as! String)
        if delay > 0 { try await Task.sleep(nanoseconds: delay) }
        if let failure { throw failure }
        let data = try JSONSerialization.data(withJSONObject: [
            "key": key.rawValue,
            "msg": "Finish response",
            "data": ""
        ])
        return try JSONDecoder().decode(T.self, from: data)
    }
}
