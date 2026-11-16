//
//  ViewsModel.swift
//  Profix
//
//  Created by Haneen on 18/01/2026.
//

import Foundation
import UIKit

enum  OrderViewType {
    case orderDetails
    case requestedServices
    case orderSummary
    
    var title : String {
        switch self {
        case .orderDetails:
            return "order_detail".localized
        case .requestedServices:
            return "requested_services".localized
        case .orderSummary:
            return "order_summary".localized
        }
    }
}

enum ViewType {
    case createOrder
    case orderDetails
    
    var backgroundColor : UIColor {
        switch self {
        case .createOrder:
            return .state
        case .orderDetails:
            return .white
        }
    }
}

enum ContextViewType {
   case cancelReason
   case feedback
    
    var title : String {
        switch self {
        case .cancelReason:
            return "cancellation_reason".localized
        case .feedback:
            return "feedback".localized
        }
    }
    
    var isRatingHidden : Bool {
        switch self {
        case .cancelReason:
            return true
        case .feedback:
            return false
        }
    }
}

enum OrderReasonSelectionType {
    case cancelOrder
    case rejectInvoice
    
    var title : String {
        switch self {
        case .cancelOrder:
            return "cancel_order".localized
        case .rejectInvoice:
            return "reject_invoice".localized
        }
    }
}

enum OrderDetailsLottieTypes {
    case cancelOrder
    case payOrder
    case sendFeedback
    case rejectInvoice
}

enum InvoiceSection: Int, CaseIterable {
    case header
    case infoList
    case summary
}
