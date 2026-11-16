//
//  OrderStatisticsCell.swift
//  ProfixProvider
//
//  Created by Haneen on 04/02/2026.
//

import UIKit

class OrderStatisticsCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : OrderStatistics){
        orderTypeLabel.text = model.orderType
        orderNumLabel.text = model.orderNum
    }
}
