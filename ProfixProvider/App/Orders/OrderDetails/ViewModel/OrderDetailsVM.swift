//
//  OrderDetailsVM.swift
//  Profix
//
//  Created by Haneen on 17/01/2026.
//

import Foundation
import Combine

protocol OrderDetailsVMProtocol {
    
    var orderDetailsPublisher: Published<BaseResponse<OrderDetailsResponse>?>.Publisher  { get }
    var addNewComplaintPublisher: Published<BaseResponse<AddComplaintsResponse>?>.Publisher { get }
    var acceptOrderPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var rejectOrderPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var acceptDatePublisher: Published<BaseResponse<String>?>.Publisher { get }
    var rejectDatePublisher: Published<BaseResponse<String>?>.Publisher { get }
    var startOrderPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var onTheWayPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var arrivedToCustomerPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var finishOrderPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var pledgePublisher: Published<BaseResponse<PledgeResponse>?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var orderId : Int { get }
    var orderDetailsModel : OrderDetailsModel? { get }
    
    func getOrderDetails()
    func cancelOrderDetailsRequest()
    func acceptOrderRequest()
    func rejectOrderRequest()
    func acceptDateRequest()
    func rejectDateRequest()
    func startOrderRequest()
    func onTheWayRequest()
    func arrivedToCustomerRequest()
    func finsihOrderRequest(code: String)
    func acceptPledge()
    
}

final class OrderDetailsVM: BaseViewModel,OrderDetailsVMProtocol {
    @Published var orderDetails : BaseResponse<OrderDetailsResponse>?
    @Published var addNewComplaint: BaseResponse<AddComplaintsResponse>?
    @Published var acceptOrder: BaseResponse<String>?
    @Published var rejectOrder: BaseResponse<String>?
    @Published var acceptDate: BaseResponse<String>?
    @Published var rejectDate: BaseResponse<String>?
    @Published var startOrder: BaseResponse<String>?
    @Published var onTheWay: BaseResponse<String>?
    @Published var arrivedToCustomer: BaseResponse<String>?
    @Published var finishOrder: BaseResponse<String>?
    @Published var pledge : BaseResponse<PledgeResponse>?
    
    var orderDetailsPublisher: Published<BaseResponse<OrderDetailsResponse>?>.Publisher  { $orderDetails }
    var addNewComplaintPublisher: Published<BaseResponse<AddComplaintsResponse>?>.Publisher { $addNewComplaint }
    var acceptOrderPublisher: Published<BaseResponse<String>?>.Publisher { $acceptOrder }
    var rejectOrderPublisher: Published<BaseResponse<String>?>.Publisher { $rejectOrder }
    var acceptDatePublisher: Published<BaseResponse<String>?>.Publisher { $acceptDate }
    var rejectDatePublisher: Published<BaseResponse<String>?>.Publisher { $rejectDate }
    var startOrderPublisher: Published<BaseResponse<String>?>.Publisher { $startOrder }
    var onTheWayPublisher: Published<BaseResponse<String>?>.Publisher { $onTheWay }
    var arrivedToCustomerPublisher: Published<BaseResponse<String>?>.Publisher { $arrivedToCustomer }
    var finishOrderPublisher: Published<BaseResponse<String>?>.Publisher { $finishOrder }
    var pledgePublisher: Published<BaseResponse<PledgeResponse>?>.Publisher { $pledge }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    let orderId : Int
    var orderDetailsModel : OrderDetailsModel?
    private var detailsTask: Task<Void, Never>?
    private var detailsRequestID = UUID()
    private let analytics: OrderAnalyticsTracking
    private var isAcceptingOrder = false
    private var hasAcceptedOrder = false
    private var isFinishingOrder = false
    private var hasFinishedOrder = false
    
    init(
        orderId: Int,
        responseHandler: ResponseHandler = DefaultResponseHandler(),
        analytics: OrderAnalyticsTracking = AppAnalytics.shared
    ) {
        self.orderId = orderId
        self.analytics = analytics
        super.init(responseHandler: responseHandler)
    }
    
    func getOrderDetails() {
        detailsTask?.cancel()
        let requestID = UUID()
        detailsRequestID = requestID
        isLoading = true
        detailsTask = Task { @MainActor [weak self] in
            guard let self else { return }
            defer {
                if self.detailsRequestID == requestID {
                    self.isLoading = false
                    self.detailsTask = nil
                }
            }
            do {
                let result = try await self.getAllRequest(OrderDetailsEndPoints.getOrderDetials(orderId: self.orderId))
                guard !Task.isCancelled, self.detailsRequestID == requestID else { return }
                guard let details = result.data?.order else { throw ResponseError.unableToDecodeResponse }
                self.orderDetailsModel = details
                self.orderDetails = result
            } catch {
                guard !Task.isCancelled, self.detailsRequestID == requestID else { return }
                self.error = error
            }
        }
    }

    func cancelOrderDetailsRequest() {
        detailsRequestID = UUID()
        detailsTask?.cancel()
        detailsTask = nil
        isLoading = false
    }

    func acceptOrderRequest(){
        guard !isAcceptingOrder, !hasAcceptedOrder else { return }
        isAcceptingOrder = true
        isLoading = true
        Task { @MainActor in
            defer {
                isAcceptingOrder = false
                isLoading = false
            }
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.acceptOrder(orderId: orderId))
                try Task.checkCancellation()
                guard result.key == .success else {
                    throw ResponseError.server(message: result.message)
                }
                hasAcceptedOrder = true
                analytics.orderAccepted(orderId: orderId)
                acceptOrder = result
                
            } catch {
                self.error = error
            }
        }
    }
    
    func rejectOrderRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.refuseOrder(orderId: orderId))
                rejectOrder = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func acceptDateRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.acceptDate(orderId: orderId))
                acceptDate = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func rejectDateRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.refuseDate(orderId: orderId))
                rejectDate = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func startOrderRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.startOrder(orderId: orderId))
                startOrder = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func onTheWayRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.onTheWay(orderId: orderId))
                onTheWay = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func arrivedToCustomerRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.arrivedToCustomer(orderId: orderId))
                arrivedToCustomer = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func finsihOrderRequest(code: String){
        guard !isFinishingOrder else {
            AnalyticsDebug.log("Finish request skipped; order_id=\(orderId), reason=request already in progress.")
            return
        }
        guard !hasFinishedOrder else {
            AnalyticsDebug.log("Finish request skipped; order_id=\(orderId), reason=order already finished in this screen.")
            return
        }
        isFinishingOrder = true
        isLoading = true
        AnalyticsDebug.log("Finish API request started; order_id=\(orderId).")
        Task { @MainActor in
            defer {
                isFinishingOrder = false
                isLoading = false
            }
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.finishOrder(orderId: orderId, code: code))
                try Task.checkCancellation()
                AnalyticsDebug.log("Finish API responded; order_id=\(orderId), key=\(result.key.rawValue).")
                // Other response keys can pass through BaseViewModel; only success finishes an order.
                guard result.key == .success else {
                    throw ResponseError.server(message: result.message)
                }
                hasFinishedOrder = true
                AnalyticsDebug.log("Finish API succeeded; requesting order_finished tracking for order_id=\(orderId).")
                analytics.orderFinished(orderId: orderId)
                finishOrder = result
            } catch {
                if error is CancellationError {
                    AnalyticsDebug.log("Finish request cancelled; no order_finished event for order_id=\(orderId).")
                } else {
                    let requestError = error as NSError
                    AnalyticsDebug.log("Finish request failed; no order_finished event for order_id=\(orderId), domain=\(requestError.domain), code=\(requestError.code).")
                }
                self.error = error
            }
        }
    }
    
    func acceptPledge(){
        isLoading = true
        Task {
            do {
                let result: BaseResponse<PledgeResponse> = try await getAllRequest(
                    OrderDetailsEndPoints.acceptPledge(orderId: orderId)
                )
                pledge = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
