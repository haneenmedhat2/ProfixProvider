//
//  PledgeResponse.swift
//  ProfixProvider
//
//  Created by Haneen on 25/06/2026.
//


import Foundation

struct PledgeResponse: Codable {
    let orderId: Int?
    let pledge: String?
    let pledgeSeen: Bool?

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case pledge
        case pledgeSeen = "pledge_seen"
    }
}
