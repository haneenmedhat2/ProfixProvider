//
//  ReceiverCell.swift
//  Esterad
//
//  Created by Haneen on 07/12/2025.
//

import UIKit
import Kingfisher

class ReceiverCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var senderTextView: UITextView!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var senderAvatar: UIImageView!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transform = CGAffineTransform(scaleX: 1, y: -1)
        AppHelper.addDashedBorder(to: senderImage)
    }
    
    func setupCell(model : ChatMessage){
        switch model.messageType {
        case .text:
            senderImage.isHidden = true
            msgView.isHidden = false
            senderTextView.text = model.content

        case .image:
            msgView.isHidden = true
            senderImage.isHidden = false
            senderImage.kf.setImage(with: URL(string: model.content ?? "") , options: [.transition(.fade(0.3))])
        }
        
        senderAvatar.kf.setImage(with: URL(string: model.avatar ?? ""),options: [.onFailureImage(UIImage(resource: .blankProfile )), .transition(.fade(0.3))])
        
        dateLabel.text = model.date
    }
}

