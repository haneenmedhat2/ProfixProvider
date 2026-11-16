//
//  OrderCell.swift
//  Esterad
//
//  Created by Haneen on 30/11/2025.
//

import UIKit

class OrderCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var stateView: UIView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        if Language.isRTL() {
            arrowImage.image = UIImage(resource: .arrowLeft01Round)
        } else {
            arrowImage.image = UIImage(resource: .rightArrow)
        }
    }

    func setupCell(id: Int , date : String , statusText : String,status : OrderStatus = .accepted , isOrder: Bool ){
        if isOrder {
            orderIdLabel.text =  "order_num".localized + "#" + "\(id)"
        } else {
            orderIdLabel.text =  "complaint_no_label".localized + "#" + "\(id)"
        }
        createdAtLabel.text = date
        stateLabel.text = statusText
        if status == .closed {
            stateView.backgroundColor = .alphaRed
            stateLabel.textColor = .error
        } else {
            stateView.backgroundColor = .state
            stateLabel.textColor = .main
        }
    }
}
