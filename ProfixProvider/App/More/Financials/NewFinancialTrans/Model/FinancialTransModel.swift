//
//  FinancialTransModel.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import Foundation

struct FinancialTransModel : Codable {
    let id : Int?
    let date : String?
    let amount : String?
    let status : OrderStatus?
    let statusText : String?
    
    enum CodingKeys: String, CodingKey {
        case id, amount, date, status
        case statusText = "status_text"
    }
}

enum SettlementMode {
    case new
    case finished
}
