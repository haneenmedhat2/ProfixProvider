//
//  InvoiceHeaderCell.swift
//  Profix
//
//  Created by Haneen on 22/01/2026.
//

import UIKit

class InvoiceHeaderCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var downloadImge: UIImageView!
    @IBOutlet weak var billID: UILabel!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : OrderDetailsModel){
        billID.text = "11111"
        orderID.text =  "#" + (model.id?.toString() ?? "")
        orderDate.text = model.date
        orderTime.text = model.time
        orderCode.text = model.code
    }
}
