//
//  Reviews.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//


struct ReviewsResponse : Codable {
    let reviews : [Reviews]
}

struct Reviews : Codable {
    let comment : String?
    let createdAt : String?
    let id : Int?
    let rate : String?
    let userAvatar : String?
    let userName : String?
    
    enum CodingKeys: String, CodingKey {
        case comment, createdAt = "created_at", id, rate, userAvatar = "user_avatar", userName = "user_name"
    }
}
