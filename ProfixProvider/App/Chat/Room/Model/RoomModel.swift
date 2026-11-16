//
//  RoomModel.swift
//  Esterad
//
//  Created by Haneen on 07/12/2025.
//

import Foundation


struct RoomsResponse : Codable {
    let rooms : [RoomModel]?
    let pagination : Pagination?
    
}

struct RoomModel : Codable {
    let id : Int?
    let userId : Int?
    let avatar : String?
    let name : String?
    let message : String?
    let time : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case avatar, name, message, time, status
    }
}

