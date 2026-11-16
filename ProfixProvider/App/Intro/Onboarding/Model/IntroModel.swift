//
//  IntroModel.swift
//  Profix
//
//  Created by Haneen on 08/12/2025.
//


import UIKit

struct IntroResponse : Codable {
    let intros : [IntroModel]?
}

enum IntroImageAssets {
    // Match the server filename, not the page position, so reordered or new slides stay correct.
    static func image(for url: URL) -> UIImage? {
        guard url.host == "profix-app.com",
              url.path.hasPrefix("/assets/uploads/intros/") else { return nil }
        return UIImage(named: "intro-" + url.deletingPathExtension().lastPathComponent)
    }
}

struct IntroModel : Codable {
    let id : Int?
    let title: String?
    let desc: String?
    let image: String?
}
