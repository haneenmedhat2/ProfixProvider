//
//  Order.swift
//  Profix
//
//  Created by Haneen on 16/01/2026.
//

import Foundation

struct OrdersResponse : Codable {
    let orders : [Orders]
    let pagination : Pagination
}

struct Orders : Codable {
    
    let id : Int?
    let createdAt : String?
    let status : OrderStatus?
    let statusText : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case status
        case statusText = "status_text"
    }
}

enum OrderStatus: String ,Codable {
    case open
    case current
    case pending
    case accepted
    case scheduled
    case inprogress
    case finished
    case closed
    case refused
    case due
    case complaintInprogress
    case on_the_way_to_client
    case arrived_to_client
    
    var apiValue: String {
        switch self {
        case .open: return "open"
        case .current: return "current"
        case .pending: return "pending"
        case .inprogress: return "inprogress"
        case .finished: return "finished"
        case .accepted: return "accepted"
        case .scheduled: return "scheduled"
        case .closed: return "closed"
        case .refused: return "refused"
        case .due: return "due"
        case .complaintInprogress: return "inprogress"
        case .on_the_way_to_client : return "on_the_way_to_client"
        case .arrived_to_client : return "arrived_to_client"
        }
    }
    
    var stringValue: String {
        switch self {
        case .open: return "complaint_new".localized
        case .current: return "current".localized
        case .pending: return "pending".localized
        case .inprogress: return "current".localized
        case .finished: return "complaint_finished".localized
        case .accepted: return "accepted".localized
        case .scheduled: return "scheduled".localized
        case .closed: return "closed".localized
        case .refused: return "refused".localized
        case .due: return "due".localized
        case .complaintInprogress: return "complaint_processing".localized
        case .on_the_way_to_client : return "on_the_way_to_customer"
        case .arrived_to_client : return "arrived_to_customer"

        }
    }
}

struct Pagination: Codable {
    let total: Int?
    let count: Int?
    let perPage: Int?
    let nextPageURL: String?
    let prevPageURL: String?
    let currentPage: Int
    let totalPages: Int
    var isLastPage: Bool {
        currentPage >= totalPages
    }
    
    enum CodingKeys: String, CodingKey {
        case total
        case count
        case perPage = "per_page"
        case nextPageURL = "next_page_url"
        case prevPageURL = "perv_page_url"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}
