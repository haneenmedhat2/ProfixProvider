//
//  HomeResponse.swift
//  Profix
//
//  Created by Haneen on 31/12/2025.
//

import Foundation

struct HomeResponse: Codable {
    let ads: [Ad]?
    let newOrdersCount : String?
    let inProgressOrderCount : String?
    let finishedOrdersCount : String?
    let closedOrderCount : String?
    let orders : [Orders]?
    let pagination :Pagination?
    
    
    enum CodingKeys: String, CodingKey {
        case ads
        case newOrdersCount = "new_orders_count"
        case inProgressOrderCount = "in_progress_order_count"
        case finishedOrdersCount = "finished_orders_count"
        case closedOrderCount = "closed_order_count"
        case orders, pagination
    }
}

extension HomeResponse {
        
     func getOrderStatisticsList() -> [OrderStatistics] {
        return [
            OrderStatistics(orderType: "new_orders".localized, orderNum: newOrdersCount ?? "0"),
            OrderStatistics(orderType: "current_orders".localized, orderNum: inProgressOrderCount ?? "0"),
            OrderStatistics(orderType: "completed_orders".localized, orderNum: finishedOrdersCount ?? "0"),
            OrderStatistics(orderType: "cancelled_orders".localized, orderNum: closedOrderCount ?? "0")
        ]
    }
}

struct PaginationModel : Codable {
    let total : Int?
    let count : Int?
    let perPage : Int?
    let nextPageUrl : String?
    let prevPageUrl : String?
    let currentPage : Int
    let totalPages : Int
    var isLastPage: Bool {
        currentPage >= totalPages
    }
    
    enum CodingKeys: String, CodingKey {
        case total, count, perPage = "per_page", nextPageUrl = "next_page_url", prevPageUrl = "prev_page_url", currentPage = "current_page", totalPages = "total_pages"
    }
}

struct OrderStatistics {
    let orderType : String
    let orderNum : String
}

struct Ad: Codable {
    let id: Int?
    let image: String?
    let title : String?
    let content : String?
    let cover : String?
}

struct HomeCategory: Codable {
    var id: Int
    let name: String
    let slug: String
    let image: String
}
