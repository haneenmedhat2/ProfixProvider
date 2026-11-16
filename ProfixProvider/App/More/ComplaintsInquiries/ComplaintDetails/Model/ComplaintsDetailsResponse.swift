//
//  ComplaintsDetailsResponse.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import Foundation

struct ComplaintsDetailsResponse : Codable {
    let ticket : ComplaintsDetailsModel?
}

struct ComplaintsDetailsModel  : Codable {
    
    let id : Int?
    let createdAt : String?
    let status : String?
    let otherMemberName : String?
    let otherMemberAvatar : String?
    let subject : String?
    let text : String?
    let answer : String?
    let order : Int?
    let images : [ComplaintsImages]?
    let answerImages : [ComplaintsImages]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case status
        case otherMemberName = "other_member_name"
        case otherMemberAvatar = "other_member_avatar"
        case subject, text, answer, order, images
        case answerImages = "answer_images"
    }
}

struct ComplaintsImages : Codable {
    let id : Int?
    let url : String?
}

struct ComplaintDetailsRow {
    let title: String
    let value: String
    let images : [ComplaintsImages]?
}

extension ComplaintsDetailsModel {
    
    func toRows() -> [ComplaintDetailsRow] {
        
        var rows: [ComplaintDetailsRow] = [
            ComplaintDetailsRow(
                title: "complaint_no_label".localized,
                value: "\(id ?? 0)",
                images: nil
            ),
            ComplaintDetailsRow(
                title: "complaint_date_label".localized,
                value: createdAt ?? "",
                images: nil
            ),
            ComplaintDetailsRow(
                title: "complaint_status_label".localized,
                value: status ?? "",
                images: nil
            ),
            ComplaintDetailsRow(
                title: "complaint_title_label".localized,
                value: subject ?? "",
                images: nil
            ),
            ComplaintDetailsRow(
                title: "complaint_details_label".localized,
                value: text ?? "",
                images: images
            )
        ]
        
        if let answer = answer, !answer.trimWhiteSpace().isEmpty {
            rows.append(
                ComplaintDetailsRow(
                    title: "admin_reply_label".localized,
                    value: answer,
                    images: answerImages
                )
            )
        }
        
        return rows
    }
}

