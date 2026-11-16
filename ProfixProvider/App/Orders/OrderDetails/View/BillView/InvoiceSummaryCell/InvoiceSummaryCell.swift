//
//  InvoiceSummaryCell.swift
//  Profix
//
//  Created by Haneen on 22/01/2026.
//

import UIKit

class InvoiceSummaryCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var servicesPrice: UILabel!
    @IBOutlet weak var addedValuePrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : OrderDetailsModel){
        servicesPrice.text = model.priceService?.toPrice
        addedValuePrice.text = model.addedValue?.toPrice
        discountPrice.text = model.discount?.toPrice
        totalPrice.text = model.totalPrice?.toPrice
        
    }
}
