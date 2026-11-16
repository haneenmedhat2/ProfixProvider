//
//  ChatCell.swift
//  Esterad
//
//  Created by Haneen on 07/12/2025.
//

import UIKit
import Kingfisher

class RoomCell : UITableViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var senderAvatar: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : RoomModel){
        senderName.text = model.name
        senderAvatar.kf.setImage(with: URL(string: model.avatar ?? ""), placeholder: UIImage(resource: .complaintsPlaceholder), options: [.onFailureImage(UIImage(resource: .complaintsPlaceholder))])
        timeLabel.text = model.time
        msgLabel.text = model.message
    }
}
