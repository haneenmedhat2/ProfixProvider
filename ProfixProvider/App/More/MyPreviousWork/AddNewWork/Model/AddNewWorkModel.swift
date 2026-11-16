//
//  AddNewWorkModel.swift
//  ProfixProvider
//
//  Created by Haneen on 27/01/2026.
//

import Foundation

struct AddNewWorkModel  {
    
    var image: Data? = nil
    var categoryId: Int? = nil
    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let image = image {
            files.append(UploadData(
                key: "image",
                data: image,
                mimeType: .jpeg,
                fileName: "\(Date().timeIntervalSince1970).jpeg"
            ))
        }
        return files
    }
}

struct UpdateWorkModel: Codable {
    var image : Data?
    var workId : Int?
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let image = image {
            files.append(UploadData(
                key: "image",
                data: image,
                mimeType: .jpeg,
                fileName: "\(Date().timeIntervalSince1970).jpeg"
            ))
        }
        return files
    }
}

enum AddNewWorkMode {
    case completeInfo
    case newItem
    case updateItem
    
    
    var title : String {
        switch self {
        case .completeInfo, .newItem:
            return "add_new_work".localized
        case .updateItem:
            return "edit_work_details".localized
        }
    }
}
