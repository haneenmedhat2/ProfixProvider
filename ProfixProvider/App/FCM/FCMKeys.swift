//
//  FCMKeys.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

enum FCMValueKeys: String {
    case id
    case type
    case orderId = "order_id"
    case ticketId = "ticket_id"
    case titleEn = "title_en"
    case titleAr = "title_ar"
    case meesageEn = "message_en"
    case messageAr = "message_ar"
    case roomId = "room_id"
    case senderName = "sender_name"
}

enum NotificationType: String, Codable {
    case unknown
    case blockNotify = "block_notify"
    case payOrder = "pay_order"
    case deleteNotify = "delete_notify"
    case newOrder = "new_order"
    case newReview = "new_review"
    case newMessage = "new_message"
    case adminNotify = "admin_notify"
    case settlementNotify = "settlement_notify"
    case userAcceptInvoice = "user_accept_invoice"
    case userCancelOrder = "user_cancel_order"
    case userRejectInvoice = "user_reject_invoice"
    case userUpdateOrderDate = "user_update_order_date"
    case ticketReply = "ticket_reply"
    case ticketInprogress = "ticket_inprogress"
    case delegateUpdateRequestRejected = "delegate_update_request_rejected"
    case delegateUpdateRequestApproved = "delegate_update_request_approved"
    case delegateUpdated = "delegate_updated"
    case delegateWorkAccepted = "delegate_work_accepted"
    case delegateWorkRejected = "delegate_work_rejected"
    case acceptJoinRequest = "accept_join_request"
    case delegateWorkUpdateRejected = "delegate_work_update_rejected"
    case delegateWorkUpdateAccepted = "delegate_work_update_accepted"
    case scheduledOrderReminder = "scheduled_order_reminder"
    case orderIsPaid = "order_is_paid"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = NotificationType(rawValue: value) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
