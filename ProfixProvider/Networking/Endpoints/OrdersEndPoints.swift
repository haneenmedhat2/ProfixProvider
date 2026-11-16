//
//  ReservationsEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 21/09/2025.
//

import Foundation
import Alamofire

struct OrdersEndPoints {
    private init() {}
}

extension OrdersEndPoints {
    
    static func getOrder(page: Int ,status: String) -> Endpoint<BaseResponse<OrdersResponse>>{
        return .init(
            method: .get,
            path: "delegate-orders",
            queries: [
                "page": page,
                "status" : status
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}

