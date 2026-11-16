//
//  LoginModel.swift
//  Esterad
//
//  Created by Haneen on 29/10/2025.
//

import Foundation

struct LoginModel : Codable {
    let phone : String?
    let password : String?
}

enum LoginRoute {
    case verification(model: LoginResponse)
    case pendingApproval(msg : String)
    case refused(msg : String)
    case home
    case completeProfile
}
