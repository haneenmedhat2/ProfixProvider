//
//  OrderDetailsModel.swift
//  Profix
//
//  Created by Haneen on 17/01/2026.
//

import Foundation
import UIKit

struct OrderDetailsResponse: Codable {
    let order: OrderDetailsModel
}

struct OrderDetailsModel: Codable {
    
    let id: Int?
    let createdAt: String?
    let status: OrderStatus?
    let statusText: String?
    let paymentType: PaymentType?
    let paymentTypeText: String?
    let paymentStatus: Bool?
    let lat: String?
    let long: String?
    let address: String?
    let time: String?
    let date: String?
    let updateTime: String?
    let updateDate: String?
    let updateStatus: String?
    let haveInvoice: Bool?
    let invoiceOrder: OrderStatus?
    let type: String?
    let price: String?
    let priceService: String?
    let appPercentage: String?
    let addedValue: String?
    let discount: String?
    let totalPrice: String?
    let invoiceImage: String?
    let description: String?
    let delegateId: Int?
    let delegateName: String?
    let delegatePhone: String?
    let delegateAvatar: String?
    let delegateLat: String?
    let delegateLong: String?
    let delegateNumOrders: String?
    let delegateRate : String?
    let userId: Int?
    let userName: String?
    let userPhone: String?
    let userAvatar: String?
    let roomId: Int?
    let services: [Service]?
    let images: [OrderImage]?
    let review: Reviews?
    let paymentInvoice: String?
    let paymentInvoiceText: String?
    let reasonRefusedInvoice: String?
    let closeReason: String?
    let isRate: Bool?
    let code: String?
    let paymentDuration: String?
    let orderTimeEditLimit: String?
    let image: String?
    let name: String?
    let invoiceUrl : String?
    let pledge: String?
    let pledgeSeen: Bool?
    let acceptTimeoutTimer: Int?
    let acceptTimeoutMessage: String?

    enum CodingKeys: String, CodingKey {
           case id
           case createdAt = "created_at"
           case status
           case statusText = "status_text"
           case paymentType = "payment_type"
           case paymentTypeText = "payment_type_text"
           case paymentStatus = "payment_status"
           case lat, long, address,time, date
           case updateTime = "update_time"
           case updateDate = "update_date"
           case updateStatus = "update_status"
           case haveInvoice = "have_invoice"
           case invoiceOrder = "invoice_order"
           case type, price
           case priceService = "price_service"
           case appPercentage = "app_percentage"
           case addedValue = "added_value"
           case discount
           case totalPrice = "total_price"
           case invoiceImage = "invoice_image"
           case description
           case delegateId = "delegate_id"
           case delegateName = "delegate_name"
           case delegatePhone = "delegate_phone"
           case delegateAvatar = "delegate_avatar"
           case delegateLat = "delegate_lat"
           case delegateLong = "delegate_long"
           case delegateNumOrders = "delegate_num_orders"
           case delegateRate = "delegate_rate"
           case userId = "user_id"
           case userName = "user_name"
           case userPhone = "user_phone"
           case userAvatar = "user_avatar"
           case roomId = "room_id"
           case services, images,review
           case paymentInvoice = "payment_invoice"
           case paymentInvoiceText = "payment_invoice_text"
           case reasonRefusedInvoice = "reason_refused_invoice"
           case closeReason = "close_reason"
           case isRate = "is_rate"
           case code
           case paymentDuration = "payment_duration"
           case orderTimeEditLimit = "order_time_edit_limit"
           case image, name
           case invoiceUrl = "invoice_url"
           case pledge
           case pledgeSeen = "pledge_seen"
           case acceptTimeoutTimer = "accept_timeout_timer"
           case acceptTimeoutMessage = "accept_timeout_message"

       }
}

extension OrderDetailsModel {
    func getOrderDetailsList() -> [OrderDataModel] {
        
        let color = status == .closed ? UIColor.red : UIColor.black
        var orderDetailsList : [OrderDataModel] = []
        orderDetailsList.append(OrderDataModel(title: "order_status".localized , value: statusText,color: color))
        orderDetailsList.append(OrderDataModel(title: "order_date".localized, value: date))
        orderDetailsList.append(OrderDataModel(title: "order_time".localized, value: time))
        return orderDetailsList
    }

    func getRequestedServicesList() -> [OrderDataModel] {
        (services ?? []).map { service in
            OrderDataModel(
                title: service.name,
                value: String(
                    format: "execution_count_format".localized,
                    service.quantity ?? 1
                )
            )
        }
    }
    
    func getOrderSummaryData() -> [OrderDataModel] {
        return [
            OrderDataModel(title: "services_value".localized, value: price?.toPrice),
            OrderDataModel(title: "tax_value".localized, value: addedValue?.toPrice),
            OrderDataModel(title: "discount_value".localized, value: discount?.toPrice),
            OrderDataModel(title: "total_value".localized ,value: totalPrice?.toPrice)
        ]
    }
    
    func getProblemDescImages() -> [ProblemDescImageType] {
       return images?.map {
            .remote($0.url)
        } ?? []
    }
}

extension OrderDetailsModel {

    var isClientPhoneHidden: Bool {
        status == .closed || status == .refused || status == .finished
    }
    
    var isCancelViewHidden : Bool {
        let closeReason = self.closeReason ?? ""
        return !(status == .closed && !closeReason.trimWhiteSpace().isEmpty )
    }
    
    var isFeedbackViewHidden : Bool {
        return !(status == .finished && isRate == true )
    }

    var isPledgeHidden: Bool {
        status == .finished || status == .refused || status == .closed
    }
    
    var isAcceptRejectOrderStackHidden : Bool {
        return !(status == .open)
    }
    
    var isAcceptRefuseDateStackHidden : Bool {
        let updateTime = self.updateTime ?? ""
        return !(status == .scheduled && !updateTime.trimWhiteSpace().isEmpty && updateStatus == "pending" )
    }
    
    var isStartOrderBtnHidden : Bool {
        return !(status == .arrived_to_client && updateStatus != "pending" )
    }
    
    var isOnTheWayToClientBtnHidden : Bool {
        return !(status == .scheduled && updateStatus != "pending" )
    }
    
    var isArrivedToClientBtnHidden : Bool {
        return !(status == .on_the_way_to_client && updateStatus != "pending" )
    }
    
    var isFinishOrderBtnStackHidden : Bool {
        let haveInvoice = self.haveInvoice ?? true
        return !(status == .inprogress && !haveInvoice )
    }
    
    var isLastFinishOrderHidden : Bool {
        let haveInvoice = self.haveInvoice ?? true
        return !(status == .inprogress && haveInvoice)
    }
    
    var isOrderNotesHidden : Bool {
        let updateTime = self.updateTime ?? ""
        return !(status == .scheduled && !updateTime.trimWhiteSpace().isEmpty && updateStatus == "pending")
    }
    
    var isChatButtonHidden : Bool {
        return !(status == .scheduled || status == .inprogress || status == .finished)
    }
    
    var isComplaintButtonHidden : Bool {
        return !( status == .inprogress || status == .finished)
    }
    
    var isBillButtonHidden : Bool {
        return !(status == .finished && invoiceOrder == .accepted )
    }
}

struct CancelReasonsResponse : Codable {
    let reasons : [CancelReasonsModel]?
}

struct CancelReasonsModel : Codable {
    var id : Int?
    var reason : String?
    var userType : String?
    var isSelected : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, reason
        case userType = "user_type"
    }
}

struct Service : Codable{
    let id : Int?
    let name : String?
    let price : Double?
    let quantity: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, price, quantity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)

        if let numericPrice = try? container.decodeIfPresent(Double.self, forKey: .price) {
            price = numericPrice
        } else if let stringPrice = try? container.decodeIfPresent(String.self, forKey: .price) {
            price = Double(stringPrice)
        } else {
            price = nil
        }
    }
}

enum PaymentType: String, Codable {
    case wallet
    case cash
    case online
    case none = ""
}

enum PaymentInvoiceType: String, Codable {
    case online
    case cash
}

struct OrderImage: Codable {
    let id: Int
    let url: String
}


struct OrderDataModel{
    var title: String?
    var value: String?
    var color : UIColor = .black
}
