//
//  FinancialDetailsResponse.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//


import Foundation

struct FinancialDetailsResponse: Codable {
    let totalValues: TotalValuesModel?
    let settlementOrders: [FinancialOrders]?

    enum CodingKeys: String, CodingKey {
        case totalValues = "total_values"
        case settlementOrders = "settlement_orders"
    }
}

enum FinancialSection {
    case status
    case totalValue
    case cancelReason
    case transferImage
    case breakDown
}
