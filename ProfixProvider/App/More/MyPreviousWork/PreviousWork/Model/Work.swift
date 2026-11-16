//
//  Work.swift
//  ProfixProvider
//
//  Created by Haneen on 05/02/2026.
//

import Foundation

struct WorksResponse : Codable {
    let works : [Works]
}

struct Works : Codable {
    let id : Int?
    let image : String?
    let categoryId: Int?
    let categoryName: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case categoryId = "category_id"
        case categoryName = "category_name"
    }
}
