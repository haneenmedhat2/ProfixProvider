//
//  HomeEndPoints.swift
//  Esterad
//
//  Created by Haneen on 08/09/2025.
//

import Foundation
import Alamofire

struct HomeEndPoints {
    private init() {}
}

extension HomeEndPoints {
    
    static func getHomeData() -> Endpoint<BaseResponse<HomeResponse>>{
        return .init(
            method: .get,
            path: "home/delegate",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getAvailability() -> Endpoint<BaseResponse<ProfileResponseModel>>{
        return .init(
            method: .post,
            path: "profile/delegate/availability",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
