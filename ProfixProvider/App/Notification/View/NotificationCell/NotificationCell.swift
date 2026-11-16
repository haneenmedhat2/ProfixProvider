//
//  NotificationCell.swift
//  Esterad
//
//  Created by Haneen on 09/12/2025.
//

import UIKit

class NotificationCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var notificationContent: UITextView!
    
    //MARK: - Properties -
    
    var notificationId : String?
    var delegate : NotificationCellProtocol?
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    func setupCell(model : NotificationModel){
        notificationId = model.id
        notificationTime.text = model.createdAt
        notificationContent.text = model.message
    }
    
    @IBAction func didTapDelete(_ sender: UIButton){
        delegate?.didTapDelete(notificationId: notificationId ?? "")
    }
}

//MARK: - Delegation Protocol -

protocol NotificationCellProtocol : AnyObject {
    func didTapDelete(notificationId : String)
}
