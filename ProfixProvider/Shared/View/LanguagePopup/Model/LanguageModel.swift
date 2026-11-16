//
//  LanguageModel.swift
//  Profix
//
//  Created by Haneen on 21/12/2025.
//

import Foundation

struct LanguageModel {
    var icon : String
    var name : String
    var apiValue : String
    var isSelected : Bool
    
    static func getLanguageList() -> [LanguageModel] {
        var isArSelected = false
        var isEnSelected = false
        
            if Language.apiLanguage() == "en" {
                isEnSelected = true
            }
            
            if Language.apiLanguage() == "ar" {
                isArSelected = true
            }
        
        return [
            LanguageModel(icon: "ar", name: "arabic language".localized, apiValue: "ar", isSelected: isArSelected),
            LanguageModel(icon: "en", name: "English", apiValue: "en", isSelected: isEnSelected)
        ]
    }
}
