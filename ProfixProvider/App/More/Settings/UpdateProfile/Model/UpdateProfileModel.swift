//
//  UpdateProfileModel.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import Foundation

struct UpdateProfileModel: Codable {
    var avatar : Data?
    var name : String?
    var categoryIds : [Int]?
    var cityId : Int?
    var lat : Double?
    var long: Double?
    var address : String?
    var bio : String?
    var bankName : String?
    var bankOwnerName : String?
    var bankAccountNumber : String?
    var bankIbanNumber : String?
    var visitRequestPrice : String?
    var commercialFile : Data?
    var commercialFileName : String?


    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let avatarData = avatar {
            files.append(UploadData(
                key: "avatar",
                data: avatarData,
                mimeType: .jpeg,
                fileName: "\(Date().timeIntervalSince1970).jpeg"
            ))
        }
        if let commercialFile = commercialFile {
            files.append(UploadData(
                key: "commercial_file",
                data: commercialFile,
                mimeType: .pdf,
                fileName: (commercialFileName as NSString?)?.deletingPathExtension ?? "commercial_\(Date().timeIntervalSince1970)"
            ))
        }
        return files
    }
}
