//
//  ChatEndPoints.swift
//  Profix
//
//  Created by Haneen on 20/01/2026.
//

import Foundation
import Alamofire

struct ChatEndPoints {
    private init() {}
}

extension ChatEndPoints {
    
    static func getRooms(name: String?,page: Int) -> Endpoint<BaseResponse<RoomsResponse>>{
        return .init(
            method: .get,
            path: "rooms",
            queries: [
                "name" : name,
                "page": page
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getSingleRoom(page : Int ,roomId : Int) -> Endpoint<BaseResponse<SingleRoomResponse>>{
        return .init(
            method: .get,
            path: "single-room",
            queries: [
                "room_id" : roomId,
                "page": page
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func uploadFile(model : UploadFileModel) -> Endpoint<BaseResponse<UploadFileResponse>>{
        return .init(
            method: .post,
            path: "upload-file",
            body: [
                "type" : model.type
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData
        )
    }
}
