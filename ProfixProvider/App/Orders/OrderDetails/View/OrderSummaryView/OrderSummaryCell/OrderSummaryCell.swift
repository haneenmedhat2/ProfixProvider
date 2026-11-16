//
//  OrderSummaryCell.swift
//  Profix
//
//  Created by Haneen on 16/01/2026.
//

import UIKit

class OrderSummaryCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Cell setup -

    func setupCell(model : OrderDataModel, isLastCell : Bool){
        keyLabel.text = model.title
        valueLabel.text = model.value
        valueLabel.textColor = model.color
        lineView.isHidden = isLastCell
    }
}
