//
//  LocationMode.swift
//  ProfixProvider
//
//  Created by Haneen on 05/02/2026.
//

import Foundation

enum LocationMode {
    case profile
    case editLocation
    
    var isConfirmBtnHidden : Bool {
        switch self {
        case .profile:
            return true
        case .editLocation:
            return false
        }
    }
}
