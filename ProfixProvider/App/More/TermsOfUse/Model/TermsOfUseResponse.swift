//
//  TermsOfUseResponse.swift
//  Profix
//
//  Created by Haneen on 20/01/2026.
//

import Foundation

struct TermsOfUseResponse : Codable {
    let termsOfUse : String?
    
    enum CodingKeys : String, CodingKey{
        case termsOfUse = "terms_of_use"
    }
}
