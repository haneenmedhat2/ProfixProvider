//
//  Fonts.swift
//  Esterad
//
//  Created by Haneen on 13/10/2025.
//


import UIKit

//MARK: - To exchange the system font to Specific font -

/*
 The limitation of this Method is you can't change more than 3 sizes for system font
 */

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}
extension UIFont {
    
    //MARK: - Enum
    enum FontNames: String {
        
        case bold
        case extraLight
        case light
        case medium
        case regular
        case semiBold
        case thin
        
        var name: String {
            
            let boldNameAr = "IBMPlexSansArabic-Bold"
            let extraLightNameAr = "IBMPlexSansArabic-ExtraLight"
            let lightNameAr = "IBMPlexSansArabic-Light"
            let mediumNameAr = "IBMPlexSansArabic-Medium"
            let regularNameAr = "IBMPlexSansArabic-Regular"
            let semiBoldNameAr = "IBMPlexSansArabic-SemiBold"
            let thinNameAr = "IBMPlexSansArabic-Thin"

            let boldNameEn = "IBMPlexSansArabic-Bold"
            let extraLightNameEn = "IBMPlexSansArabic-ExtraLight"
            let lightNameEn = "IBMPlexSansArabic-Light"
            let mediumNameEn = "IBMPlexSansArabic-Medium"
            let regularNameEn = "IBMPlexSansArabic-Regular"
            let semiBoldNameEn = "IBMPlexSansArabic-SemiBold"
            let thinNameEn = "IBMPlexSansArabic-Thin"

            switch self {
            case .bold:
                return Language.isRTL() ? boldNameAr : boldNameEn
            case .extraLight:
                return Language.isRTL() ? extraLightNameAr : extraLightNameEn
            case .light:
                return Language.isRTL() ? lightNameAr : lightNameEn
            case .medium:
                return Language.isRTL() ? mediumNameAr : mediumNameEn
            case .regular:
                return Language.isRTL() ? regularNameAr : regularNameEn
            case .thin:
                return Language.isRTL() ? thinNameAr : thinNameEn
            case .semiBold:
                return Language.isRTL() ? semiBoldNameAr : semiBoldNameEn

            }
        }
    }
    
    //MARK:- Objc Methods

    @objc class func myBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.bold.name, size: size)!
    }
    @objc class func myMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.medium.name, size: size)!
    }
    @objc class func myRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.regular.name, size: size)!
    }
    @objc class func mySemiBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.semiBold.name, size: size)!
    }
    @objc class func myLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.light.name, size: size)!
    }
    @objc class func myExtraLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.extraLight.name, size: size)!
    }
    @objc class func myThin(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.thin.name, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }
        var fontName = ""
        switch fontAttribute {

        case "CTFontBoldUsage":
            fontName = FontNames.bold.name

        case "CTFontMediumUsage":
            fontName = FontNames.medium.name

        case "CTFontEmphasizedUsage":
            fontName = FontNames.semiBold.name

        case "CTFontLightUsage":
            fontName = FontNames.light.name

        case "CTFontThinUsage":
            fontName = FontNames.thin.name

        case "CTFontUltraLightUsage":
            fontName = FontNames.extraLight.name
        default:
            fontName = FontNames.regular.name
        }

        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .semibold:
            return mySemiBoldFont(ofSize: size)
        case .bold, .heavy:
            return myBoldFont(ofSize: size)
        case .medium:
            return myMediumFont(ofSize: size)
        case .light, .thin, .ultraLight:
            return myLightFont(ofSize: size)
        default:
            return myRegularFont(ofSize: size)
        }
    }
    
    

    
    //MARK: - Initilization
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))), let mySystemFontMethod = class_getClassMethod(self, #selector(myRegularFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))), let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))), let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myRegularFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
        if let systemFontWeightMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
           let mySystemFontWeightMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:weight:))) {
            method_exchangeImplementations(systemFontWeightMethod, mySystemFontWeightMethod)
        }

        // Trick to get over the lack of UIFont.init(coder:))
    }
}


/*
 This also to change font for all the app font but at some cases font not change (ex:- UIAlertController action fonts) so we use the above extension too
 */
enum FontFamilyName: String {
    case cairo = "Cairo"
    case ExpoArabic = "ExpoArabic"
}

extension UILabel {
    @objc var substituteFontName : String {
        get {
            return self.font.fontName
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased()
            var fontName = newValue
            
            if fontNameToTest.range(of: "black") != nil {
                fontName += "-Black"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "semibold") != nil {
                fontName += "-SemiBold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            }else {
                fontName += "-SemiBold"
            }
            
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }
}
extension UITextView {
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            var fontName = newValue
            
            if fontNameToTest.range(of: "black") != nil {
                fontName += "-Black"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "semibold") != nil {
                fontName += "-SemiBold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            }else {
                fontName += "-SemiBold"
            }
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}
extension UITextField {
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            var fontName = newValue
            
            if fontNameToTest.range(of: "black") != nil {
                fontName += "-Black"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "semibold") != nil {
                fontName += "-SemiBold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            }else {
                fontName += "-SemiBold"
            }
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UIFont {
    static func appFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .bold:
            return myBoldFont(ofSize: size)
        case .semibold:
            return mySemiBoldFont(ofSize: size)
        case .medium:
            return myMediumFont(ofSize: size)
        case .light:
            return myLightFont(ofSize: size)
        case .regular:
            return myRegularFont(ofSize: size)
        default:
            return myRegularFont(ofSize: size)
        }
    }
}
