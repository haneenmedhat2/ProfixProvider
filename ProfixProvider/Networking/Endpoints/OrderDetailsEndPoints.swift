//
//  ReservationDetailsEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 21/09/2025.
//

import Foundation
import Alamofire

struct OrderDetailsEndPoints {
    private init() {}
}

extension OrderDetailsEndPoints {
    
    static func getOrderDetials(orderId : Int) -> Endpoint<BaseResponse<OrderDetailsResponse>>{
        return .init(
            method: .get,
            path: "delegate-single-order",
            queries: [
                "order_id" : orderId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func acceptOrder(orderId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-accept-order",
            body: [
                "order_id" : orderId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func refuseOrder(orderId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-refuse-order",
            body: [
                "order_id" : orderId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func acceptDate(orderId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-accept-date",
            body: [
                "order_id" : orderId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func refuseDate(orderId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-refuse-date",
            body: [
                "order_id" : orderId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func startOrder(orderId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-intransit-order",
            body: [
                "order_id" : orderId,
                "status" : "inprogress"
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func onTheWay(orderId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-intransit-order",
            body: [
                "order_id" : orderId,
                "status" : "on_the_way_to_client"
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func arrivedToCustomer(orderId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-intransit-order",
            body: [
                "order_id" : orderId,
                "status" : "arrived_to_client"
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func createInvoice(orderId : Int ,service : String , price : String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-create-order-invoice",
            body: [
                "order_id" : orderId,
                "services" : service,
                "price" : price
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func finishOrder(orderId : Int ,code : String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate-finish-order",
            body: [
                "order_id" : orderId,
                "code" : code
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func acceptPledge(orderId: Int) -> Endpoint<BaseResponse<PledgeResponse>>{
        return .init(
            method: .post,
            path: "pledge",
            body: [
                "order_id": orderId
            ],
            headerType: .authorized(token: Session.token ?? ""),
            isMultipart: true
        )
    }
}
