//
//  Record.swift
// NewBase
//
//  Created by Mohamed Hadwa on 11/08/2024.
//

import Foundation


struct GeneralRecordModel {
    
    enum ImageType {
        case onlineRecord
        case offlineRecord
    }
    
    let type: ImageType
    var offlineRecord: OfflineRecordModel?
    var onlineRecord: OnlineRecordModel?
    
    init(offlineRecord: OfflineRecordModel) {
        self.offlineRecord = offlineRecord
        self.type = .offlineRecord
    }
    
    init(onlineRecord: OnlineRecordModel) {
        self.onlineRecord = onlineRecord
        self.type = .onlineRecord
    }
}

struct OnlineRecordModel: Codable {
    var id: Int? = nil
    var title: String? = nil
    var url: String? = nil
    var image: String? = nil
    var file: String? = nil

    init(id: Int? = nil, title: String? = nil, url: String? = nil, image: String? = nil, file: String? = nil) {
        self.id = id
        self.title = title
        self.url = url
        self.image = image
        self.file = file
    }
}


struct OfflineRecordModel {
    
    var data: [Data]
    init(data: [Data]) {
        self.data = data
    }
}
