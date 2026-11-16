//
//  BaseResponse.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    var key: ServerResponseKey
    var message: String
    var data: T?
    var userStatus : ServerUserStatus?
    
    enum CodingKeys: String, CodingKey {
        case key
        case message = "msg"
        case data
        case userStatus = "user_status"
    }
}
