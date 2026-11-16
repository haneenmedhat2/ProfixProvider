//
//  UILabel.swift
//  Esterad
//
//  Created by Haneen on 16/10/2025.
//


import UIKit

extension UILabel {
    static func underline(_ label: UILabel) {
        guard let text = label.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
    }
    
    func setStrikeThrough(text: String, strikePart: String) {
        let attributedString = NSMutableAttributedString(string: text)

        let nsText = text as NSString
        let range = nsText.range(of: strikePart)

        if range.location != NSNotFound {
            attributedString.addAttribute(.strikethroughStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: range)
        }

        self.attributedText = attributedString
    }
    
    func addLineThrough() {
        guard let text = self.text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        
        self.attributedText = attributeString
    }
}

extension UIButton {
    static func underlineButtonTitle(_ button: UIButton) {
        guard let title = button.title(for: .normal) else { return }
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: button.titleColor(for: .normal) ?? UIColor.label
            ]
        )
        
        button.setAttributedTitle(attributedTitle, for: .normal)
    }
}
