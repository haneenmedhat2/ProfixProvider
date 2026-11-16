//
//  FinancialStatusCell.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit

class FinancialStatusCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : FinancialStatus){
        statusView.backgroundColor = model.backgroundColor
        statusLabel.textColor = model.fontColor
        statusLabel.text = model.title
    }
}
