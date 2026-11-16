//
//  CGColor.swift
// NewBase
//
//  Created by MGAbouarab on 27/12/2023.
//

import UIKit

extension CGColor {
    
    static var mainCGColor: CGColor {
        return UIColor.main.cgColor
    }
//    static var mainWithAlpha: CGColor {
//        let x = UIColor.mainWithAlpha
//        return x.cgColor
//    }
//    
//    static var secondary: CGColor {
//        let x = UIColor.secondary
//        return x.cgColor
//    }
//    static var secondaryWithAlpha: CGColor {
//        let x = UIColor.secondaryWithAlpha
//        return x.cgColor
//    }
    
}
extension UIColor {
    public convenience init?(hex: String, alpha: CGFloat) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
