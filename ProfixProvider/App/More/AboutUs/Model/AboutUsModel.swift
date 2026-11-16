//
//  AboutUsModel.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import Foundation

struct AboutUsResponse : Codable {
    let aboutUs : String?
    
    enum CodingKeys : String, CodingKey {
        case aboutUs = "about-us"
    }
}
