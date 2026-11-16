//
//  ComplaintsResponse.swift
//  Profix
//
//  Created by Haneen on 25/12/2025.
//

import Foundation

struct ComplaintsResponse : Codable {
    let tickets : [ComplaintModel]?
}

struct ComplaintModel : Codable {
    let id : Int?
    let createdAt : String?
    let status : String?
    let text : String?
    let order : Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case status, text, order
    }
}
