//
//  NotificationModel.swift
//  Profix
//
//  Created by Haneen on 09/12/2025.
//

import Foundation

struct NotificationResponse : Codable {
    let notifications : [NotificationModel]
    let pagination : Pagination
}

struct NotificationModel : Codable {
    let id : String?
    let icon : String?
    let title : String?
    let message : String?
    let type : String?
    let orderId : Int?
    let ticketId : Int?
    let notificationType : NotificationType?
    let createdAt : String?
    
    enum CodingKeys: String, CodingKey {
        case id, icon, title, message, type
        case orderId = "order_id"
        case ticketId = "ticket_id"
        case notificationType = "notification_type"
        case createdAt = "created_at"
    }
}


struct NotificationCountResponse : Codable {
    let notificationCount : Int?
    
    enum CodingKeys: String, CodingKey {
        case notificationCount = "num_not_seen_notifications"
    }
}
