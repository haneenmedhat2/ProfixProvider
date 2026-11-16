//
//  FinancialDueModel.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//

import Foundation
import UIKit

struct FinancialDueModel : Codable {
    let totalValues : TotalValuesModel?
    let orders : [FinancialOrders]?
    
    enum CodingKeys: String, CodingKey {
        case totalValues = "total_values"
        case orders
    }
}

struct TotalValuesModel : Codable{
    let id: Int?
    let totalPrice : String?
    let totalAppPercentage : String?
    let totalAddedValue : String?
    let totalDue : String?
    let totalPriceText : String?
    let totalAppPercentageText : String?
    let totalAddedValueText : String?
    let totalDueText : String?
    let image: String?
    let refuseReason: String?
    let status: OrderStatus?
    let statusText: String?

    enum CodingKeys: String, CodingKey {
        case id,image,status
        case totalPrice = "total_price"
        case totalAppPercentage = "total_app_percentage"
        case totalAddedValue = "total_added_value"
        case totalDue = "total_due"
        case totalPriceText = "total_price_text"
        case totalAppPercentageText = "total_app_percentage_text"
        case totalAddedValueText = "total_added_value_text"
        case totalDueText = "total_due_text"
        case refuseReason = "refuse_reason"
        case statusText = "status_text"
    }
}

extension TotalValuesModel {
    func getTotalValuesList() -> [OrderDataModel] {
        return [
            OrderDataModel(title: "total_amount".localized, value: totalPrice ),
            OrderDataModel(title: "total_app_commission".localized, value: totalAppPercentage ),
            OrderDataModel(title: "total_tax_amount".localized, value: totalAddedValue),
            OrderDataModel(title: "amount_due".localized, value: totalDue )
        ]
    }
    
    func getFinancialStatusModel() -> FinancialStatus {
        switch status {
        case .pending:
            return FinancialStatus(title: "settlement_request_sent".localized, backgroundColor: .state, fontColor: .main)
        case .accepted:
            return FinancialStatus(title: "settlement_request_approved".localized, backgroundColor: .successView, fontColor: .success)
        case .refused:
            return FinancialStatus(title: "request_rejected".localized, backgroundColor: .alphaRed, fontColor: .error)
        default :
            return  FinancialStatus(title: "settlement_request_sent".localized, backgroundColor: .state, fontColor: .main)
        }
    }
}

struct FinancialOrders : Codable {
    let id : Int?
    let orderNum : Int?
    let date : String?
    let time : String?
    let orderPrice : String?
    let orderTotalPrice : String?
    let orderAppPercentage : String?
    let orderAddedValue : String?
    let statusText : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderNum = "order_num"
        case date, time
        case orderPrice = "order_price"
        case orderTotalPrice = "order_total_price"
        case orderAppPercentage = "order_app_percentage"
        case orderAddedValue = "order_added_value"
        case statusText = "status_text"
    }
}

struct Settlement : Codable {
    let totalPrice : Double?
    let totalAddedValue : Double?
    let totalAppPercentage : Double?
    let totalDue : Double?
}


struct FinancialStatus {
    let title : String
    let backgroundColor : UIColor
    let fontColor : UIColor
}
