//
//  ResetPasswordModel.swift
//  Esterad
//
//  Created by Haneen on 29/10/2025.
//

import Foundation

struct ResetPasswordModel : Codable {
    
    let phone : String
    let password : String
    let passwordConfirmation : String
    
    enum CodingKeys : String, CodingKey {
        case phone = "phone"
        case password = "password"
        case passwordConfirmation = "password_confirmation"
    }
}
