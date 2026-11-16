//
//  NetworkConstants.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

struct NetworkConstants {
    private init() {}
    static let domain = "https://profix-app.com"
    static let port = "4942"
    static var server: String {
        return domain + "/api/"
    }
    static var socket: String {
        "\(domain):\(port)"
    }
}
