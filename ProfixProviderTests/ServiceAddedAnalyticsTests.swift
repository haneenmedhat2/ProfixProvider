import XCTest
@testable import ProfixProvider

@MainActor
final class ServiceAddedAnalyticsTests: XCTestCase {
    func testTracksOnlySuccessfulServiceCreationAndPreventsDuplicates() async throws {
        let handler = ServiceResponseHandler()
        let analytics = ServiceAnalyticsSpy()
        let viewModel = AddNewServiceVM(responseHandler: handler, analytics: analytics)
        let service = AddNewServiceModel(
            categoryId: 1,
            subcategoryId: 2,
            price: "100",
            decription: "Test service",
            serviceId: nil
        )

        handler.key = .needApprove
        viewModel.addServiceRequest(model: service)
        try await waitUntilIdle(viewModel)
        XCTAssertEqual(analytics.addedCount, 0)
        XCTAssertNil(viewModel.addService)

        handler.key = .success
        viewModel.addServiceRequest(model: service)
        viewModel.addServiceRequest(model: service)
        try await waitUntilIdle(viewModel)
        viewModel.addServiceRequest(model: service)

        XCTAssertEqual(handler.paths, ["add-service", "add-service"])
        XCTAssertEqual(analytics.addedCount, 1)
        XCTAssertEqual(viewModel.addService?.key, .success)
    }

    private func waitUntilIdle(_ viewModel: AddNewServiceVM) async throws {
        for _ in 0..<200 {
            if !viewModel.isLoading { return }
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        XCTFail("Service request did not complete")
    }
}

private final class ServiceAnalyticsSpy: ServiceAnalyticsTracking {
    var addedCount = 0
    func serviceAdded() { addedCount += 1 }
}

private final class ServiceResponseHandler: ResponseHandler {
    var key: ServerResponseKey = .success
    var paths: [String] = []

    func get<T: Decodable>(_ endpoint: Endpoint<T>, progress: ((Int) -> Void)?) async throws -> T {
        paths.append(endpoint.path)
        let payload: [String: Any] = [
            "key": key.rawValue,
            "msg": "Test response",
            "data": ""
        ]
        return try JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: payload))
    }
}
