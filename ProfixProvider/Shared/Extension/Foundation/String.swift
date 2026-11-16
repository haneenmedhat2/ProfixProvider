//
//  String.swift
// NewBase
//
//  Created by MGAbouarab on 08/01/2024.
//

import Foundation
import UIKit

extension String {
    func trimWhiteSpace() -> String{
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return newValue
    }
    func isValidEmail() -> Bool {
        let testEmail = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return testEmail.evaluate(with: self)
    }
    func isValidPhoneNumber(pattern: String) -> Bool {
        return self.range(of: pattern ,options: .regularExpression) != nil
    }
    func isValidIBAN() -> Bool {
        let ibanRegex = #"^SA\d{22}$"#
        //        let ibanRegex = #"^[A-Z]{2}\d{22}$"#
        let ibanTest = NSPredicate(format: "SELF MATCHES %@", ibanRegex)
        return ibanTest.evaluate(with: self)
    }
    
    func toDouble() -> Double {
        let cleanString = self.replacingOccurrences(of: ",", with: "")
        return Double(cleanString) ?? 0.0
    }
    func toFloat() -> Float {
        return Float(self) ?? 0.0
    }
    
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date
    }
    func toDay() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: self)
        return date
    }
    
    
    @available(iOS 13.0, *)
    func toTimeAgo() -> String {
        guard let date = self.toDate() else {return String()}
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    

    
}

extension String {
    func convertArabicToEnglish() -> String {
        let arabicNumerals = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
        let englishNumerals = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        var convertedString = self
        
        for (index, arabicNumeral) in arabicNumerals.enumerated() {
            convertedString = convertedString.replacingOccurrences(of: arabicNumeral, with: englishNumerals[index])
        }
        
        return convertedString
    }
    
    func htmlToPlainText(_ html: String) -> String {
        guard let data = html.data(using: .utf8) else { return html }
        
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return html
    }
    
}
extension String {
    func onlyDigits() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

extension String {
    
    var toPrice: String {
        let cleaned = self.replacingOccurrences(of: ",", with: "")
        var double = Double(cleaned) ?? 0
        
        let formatted = double.round(points: 2)
            .replacingOccurrences(of: ".00", with: "")
        
        let languageCode = Locale.current.languageCode ?? "en"
        
        if languageCode == "ar" {
            return "\(formatted) \u{FDFC}"
        } else {
            return "\u{FDFC} \(formatted)"
        }
    }
}


extension Double {
    func round(points: Int) -> String {
        let format = "%.\(points)f"
        return String(format: format, self)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = cleanedHTML.data(using: .utf8) else { return nil }
        do {
            let attributedText = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding:String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            // Apply RTL & formatting
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .right
            attributedText.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSMakeRange(0, attributedText.length)
            )
            return attributedText
        } catch {
            print("HTML parsing error:", error)
            return nil
        }
    }
}
extension String {
    var withBulletForListItems: String {
        replacingOccurrences(of: "<li>", with: "<li>• ")
    }
}

extension String {
    var cleanedHTML: String {
        self
            .replacingOccurrences(of: "<pre>", with: "")
            .replacingOccurrences(of: "</pre>", with: "")
            .replacingOccurrences(of: "<li>", with: "<li>• ") // adds bullet
    }
}
