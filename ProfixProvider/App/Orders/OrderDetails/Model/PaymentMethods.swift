//
//  PaymentMethods.swift
//  Profix
//
//  Created by Haneen on 18/01/2026.
//

import Foundation


struct PaymentMethodsResponse : Codable {
    let paymentMethod : [PaymentMethodModel]?
    
    enum CodingKeys : String,CodingKey {
        case paymentMethod = "payment_methods"
    }
}

struct PaymentMethodModel : Codable {
    let id : Int?
    let key : String?
    let name : String?
    let desc : String?
    let image : String?
    var isSelected : Bool = false
    
    enum CodingKeys : String,CodingKey {
        case id,key,name,desc,image
    }
}

enum PaymentNavigationType {
    case order
    case invoice
}
