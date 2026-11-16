//
//  RequestHeader.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

enum RequestHeaderType {
    
    case authorized(token: String)
    case unauthorized
    case ifAuthorized(token: String?)
    
    var header: [String:String] {
        
        var commonHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "lang": Language.apiLanguage()
        ]
        
        switch self {
        case .authorized(let token):
            commonHeaders["Authorization"] = "Bearer \(token)"
            return commonHeaders
        case .ifAuthorized(let token):
            guard let token , token != "" else { return commonHeaders }
            commonHeaders["Authorization"] = "Bearer \(token)"
            return commonHeaders
        case .unauthorized:
            return commonHeaders
        }
        
    }
    
}
