//
//  AddComplaintsModel.swift
//  Profix
//
//  Created by Haneen on 28/12/2025.
//

import Foundation
import UIKit

struct AddComplaintsModel: Codable {
    let subject: String
    let text: String
    let delegateId: Int?
    var images: [Data] = []
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        
        for (index, imageData) in images.enumerated() {
            files.append(
                UploadData(
                    key: "images[\(index)]",
                    data: imageData,
                    mimeType: .jpeg,
                    fileName: "image_\(index)_\(Date().timeIntervalSince1970).jpeg"
                )
            )
        }
        
        return files
    }
    
    enum CodingKeys: String, CodingKey {
        case subject, text
        case delegateId = "delegate_id"
    }
}


struct AddComplaintsResponse : Codable {
    let ticketId : Int?
    
    enum CodingKeys: String, CodingKey {
        case ticketId = "ticket_id"
    }
}

struct ComplaintImageItem {
    let image: UIImage
    let data: Data
}
