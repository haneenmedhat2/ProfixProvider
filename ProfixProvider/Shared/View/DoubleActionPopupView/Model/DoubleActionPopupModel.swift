//
//  DoubleActionPopupModel.swift
//  Esterad
//
//  Created by Haneen on 05/11/2025.
//

import Foundation

enum DoubleActionPopupType {
    case deleteAccount
    case signout
    case deleteWork
    case deleteService
    case deleteNotifications
    
    var mainTitle: String {
        switch self {
        case .deleteAccount:
            return "delete_account_title".localized
        case .signout:
            return "logout_title".localized
        case .deleteWork:
            return "delete_work".localized
        case .deleteService:
            return "delete_service".localized
        case .deleteNotifications:
            return "delete_all".localized
        }
    }
    
    var secTitle: String {
        switch self {
        case .deleteAccount:
            return "delete_account_message".localized
        case .signout:
            return "logout_message".localized
        case .deleteWork:
            return "confirm_delete_work".localized
        case .deleteService:
            return "confirm_delete_service".localized
        case .deleteNotifications:
            return "delete_notification_message".localized
        }
    }
    
    var firstBtnTitle: String {
        return "yes".localized
    }
    
    var imageName: String {
        return "alert"
    }
    
    var secBtnTitle: String {
        return "no".localized
        
    }
}
