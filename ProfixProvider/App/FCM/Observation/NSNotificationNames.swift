//
//  NSNotificationNames.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

extension NSNotification.Name {
    
    /*
     Enum for Holding all strings keys as rawValues to avoid using Strings
     */
    
    private enum Names: String {
        case order
        case block
        case serviceChanged
        case myWorkChanged
        case appDidBecomeActive

    }
    
    /*
     All Notification cases
     */
    
    static let isOrderChanged = Notification.Name(rawValue: Names.order.rawValue)
    static let isAdminNotify = Notification.Name(rawValue: Names.block.rawValue)
    static let isServiceChanged = Notification.Name(rawValue: Names.serviceChanged.rawValue)
    static let isWorChanged = Notification.Name(rawValue: Names.myWorkChanged.rawValue)
    static let appDidBecomeActive = Notification.Name(rawValue: Names.appDidBecomeActive.rawValue)


}
