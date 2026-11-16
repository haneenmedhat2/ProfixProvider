//
//  ServicesModel.swift
//  ProfixProvider
//
//  Created by Haneen on 08/02/2026.
//

import Foundation

struct ServicesResponse : Codable {
    let services : [Services]
}

struct Services : Codable {
    let categoryId : Int?
    let categoryName : String?
    let description : String?
    let id : Int?
    let name : String?
    let price : String?
    let subcategoryId : Int?
    let subcategoryName : String?
    let canEditDelete : Bool?
    var isSelected : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id", categoryName = "category_name", description, id, name, price, subcategoryId = "subcategory_id", subcategoryName = "subcategory_name" , canEditDelete = "can_edit_delete"
    }
}
