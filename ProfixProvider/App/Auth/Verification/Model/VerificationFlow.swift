//
//  VerificationFlow.swift
//  Profix
//
//  Created by Haneen on 15/12/2025.
//

import Foundation

enum VerificationFlow {
    case signup
    case resetPassword
    
    var title : String {
        switch self {
        case .signup:
            return "verification_code".localized
        case .resetPassword:
            return "Forgot_password".localized
        }
    }
}

