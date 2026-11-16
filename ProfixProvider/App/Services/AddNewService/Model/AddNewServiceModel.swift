//
//  AddNewServiceModel.swift
//  ProfixProvider
//
//  Created by Haneen on 08/02/2026.
//

import Foundation

struct AddNewServiceModel : Codable {
    var categoryId : Int?
    var subcategoryId : Int?
    var price : String?
    var decription : String?
    var serviceId : Int?
}

struct SubCategoryResponse : Codable {
    let subcategories : [SubCategoryModel]?
}

struct SubCategoryModel : Codable {
    let id : Int?
    let name : String?
    let image : String?
}

extension SubCategoryModel : SelectionModelPicker {
    var pickerId: Int { id  ?? 0 }
    var pickerName: String { name ?? "" }
}

