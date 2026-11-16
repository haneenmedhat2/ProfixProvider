//
//  FinancialBreakDownCell.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit

class FinancialBreakDownCell: UICollectionViewCell {

    @IBOutlet weak var financialBreakdownView: FinancialBreakdownView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(model: FinancialOrders){
        financialBreakdownView.getDataSource(model: model)
    }
}
