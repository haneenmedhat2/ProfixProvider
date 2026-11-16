//
//  Language.swift
//
//  Created by MGAbouarab®

import UIKit
struct Language {
    
    enum Languages {
        static let en = "en"
        static let ar = "ar"
    }
    
    private static let selectedLangKey = "SelectedAppLanguage"
    
    static func currentLanguage() -> String {
        let systemLangs = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]
        let firstLang = systemLangs?.first ?? "en"
        let languageCode = firstLang.components(separatedBy: "-").first ?? "en"
        return languageCode
    }
    
    static func setAppLanguage(lang: String) {
        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
        UserDefaults.standard.set(lang, forKey: selectedLangKey) // ✅ persist selected language
        UserDefaults.standard.synchronize()
        Language.handleViewDirection()
    }
    
    static func apiLanguage() -> String {
        if currentLanguage().contains(Languages.ar) {
           return Languages.ar
        }else{
            return Languages.en
        }
    }
    
    static func isRTL() -> Bool {
        let rtlLanguages = [Languages.ar]
        return rtlLanguages.contains(self.currentLanguage())
    }
    
    
    static func handleViewDirection() {
    UIPageControl.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    UIStackView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    UISwitch.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    UIView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    UICollectionView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    UITextField.appearance().textAlignment = isRTL() ? .right : .left
    //UITextField.appearance().textAlignment = .center
    UILabel.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    UITextView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    UITextField.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight


    UISearchBar.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight


    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var payLocalized: String {
        return NSLocalizedString(self, tableName: "PayLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
    var validationLocalized: String {
        return NSLocalizedString(self, tableName: "ValidationLocalized", bundle: Bundle.main, value: "", comment: "")
    }
    var helperLocalizable: String {
        return NSLocalizedString(self, tableName: "HelperLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
    var coreLocalizable: String {
        return NSLocalizedString(self, tableName: "CoreLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
}



//MARK: Localizable
public protocol Localizable {
    var localized: String { get }
}

// MARK: XIBLocalizable
public protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            //textColor = .subFont
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UINavigationItem: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

extension UIBarItem: XIBLocalizable { // Localizes UIBarButtonItem and UITabBarItem
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

// MARK: Special protocol to localize multiple texts in the same control
public protocol XIBMultiLocalizable {
    var xibLocKeys: String? { get set }
}

extension UISegmentedControl: XIBMultiLocalizable {
    @IBInspectable public var xibLocKeys: String? {
        get { return nil }
        set(keys) {
            guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else { return }
            for (index, title) in keys.enumerated() {
                setTitle(title.localized, forSegmentAt: index)
            }
        }
    }
}

// MARK: Special protocol to localizaze UITextField's placeholder
public protocol UITextFieldXIBLocalizable {
    var xibPlaceholderLocKey: String? { get set }
}

extension UITextField: UITextFieldXIBLocalizable {
    @IBInspectable public var xibPlaceholderLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}
