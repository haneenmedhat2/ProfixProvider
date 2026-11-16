//
//  ServerResponseKey.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

enum ServerResponseKey: String, Decodable {
    case success 
    case fail
    case unauthenticated = "unauthenticated"
    case needActive = "needActive"
    case exception
    case blocked
    case needApproval
    case needApprove
    case refused
}

enum ServerUserStatus: String, Decodable {
    case pending
    case active
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = (try? container.decode(String.self)) ?? ""

        self = ServerUserStatus(rawValue: rawValue) ?? .unknown
    }
}
