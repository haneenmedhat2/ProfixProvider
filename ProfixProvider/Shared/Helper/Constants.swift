//
//  Constants.swift
// NewBase
//
//  Created by Mohamed Hadwa on 13/04/2024.
//


import UIKit

final class ViewConstants {
    
    static let shared: ViewConstants = ViewConstants()
    
    private init() {}
    
    let smallCornerRadius: CGFloat = 8
    let mediumCornerRadius: CGFloat = 12
    let largeCornerRadius: CGFloat = 24
    
    let smallAnimationTime: CGFloat = 0.2
    let mediumAnimationTime: CGFloat = 0.5
    let largeAnimationTime: CGFloat = 1
    
}

enum SFSymbol: String {
    case eyeFill = "eye.fill"
    case eyeSlashFill = "eye.slash.fill"
    case starFill = "star.fill"
    case starLeadingHalfFilled = "star.leadinghalf.filled"
    case star = "star"
    case cheveronLeft = "chevron.left"
    case cheveronRight = "chevron.right"
    case cheveronUp = "chevron.up"
    case cheveronDown = "chevron.down"
    case clock = "clock"
    case search = "magnifyingglass"
    case trash = "trash.fill"
    case warning = "exclamationmark.triangle"
    case success = "checkmark.seal"
    case error = "xmark.seal"
    case copy = "doc.on.doc.fill"
    case favorite = "heart.fill"
    case unfavorite = "heart"
    case notifyMuteSound = "bell.slash.fill"
    case notifySound = "bell.fill"
    case cart = "cart.fill"
}
var appCurrency = {
    return "\u{FDFC}"
}()
