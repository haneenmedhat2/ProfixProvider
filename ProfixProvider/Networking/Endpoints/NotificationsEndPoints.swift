//
//  NotificationsEndPoints.swift
//  Profix
//
//  Created by Haneen on 05/09/2025.
//

import Foundation
import Alamofire


struct NotificationsEndPoints {
    private init() {}
}

extension NotificationsEndPoints {
    
    static func getNotifications(page: Int) -> Endpoint<BaseResponse<NotificationResponse>>{
        return .init(
            method: .get,
            path: "notifications",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteNotification(id:String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delete-notification",
            body: [
                "notification_id" : id
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteAll() -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delete-notification-all",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func notificationCount() -> Endpoint<BaseResponse<NotificationCountResponse>>{
        return .init(
            method: .get,
            path: "unseen-notifications-count",
            headerType: .authorized(token: Session.token ?? "")

        )
    }
}

