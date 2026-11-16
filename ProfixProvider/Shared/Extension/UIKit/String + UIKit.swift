//
//  String + UIKit.swift
// NewBase
//
//  Created by MGAbouarab on 22/01/2024.
//

import UIKit

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return nil }
//        do {
//            let attributedText = try NSMutableAttributedString(
//                data: data,
//                options: [
//                    .documentType: NSAttributedString.DocumentType.html,
//                    .characterEncoding:String.Encoding.utf8.rawValue
//                ],
//                documentAttributes: nil)
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineBreakMode = .byWordWrapping
//            paragraphStyle.alignment = .right
//            attributedText.addAttribute(
//                NSAttributedString.Key.paragraphStyle,
//                value: paragraphStyle,
//                range: NSMakeRange(0, attributedText.length)
//            )
//            return attributedText
//        } catch {
//            return nil
//        }
//    }
//}
