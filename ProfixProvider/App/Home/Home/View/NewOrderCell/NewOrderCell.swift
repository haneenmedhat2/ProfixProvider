//
//  NewOrderCell.swift
//  ProfixProvider
//
//  Created by Haneen on 04/02/2026.
//

import UIKit

class NewOrderCell: UICollectionViewCell {

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

    func setupCell(model : Orders ){
        orderIdLabel.text =  "order_num".localized + "#" + "\(model.id ?? 0)"
        createdAtLabel.text = model.createdAt
        stateLabel.text = model.statusText
        if model.status == .closed {
            stateView.backgroundColor = .alphaRed
            stateLabel.textColor = .error
        } else {
            stateView.backgroundColor = .state
            stateLabel.textColor = .main
        }
    }
}
