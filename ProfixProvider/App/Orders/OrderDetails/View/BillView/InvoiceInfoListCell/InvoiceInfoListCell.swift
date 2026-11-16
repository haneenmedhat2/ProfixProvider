//
//  InvoiceInfoListCell.swift
//  Profix
//
//  Created by Haneen on 22/01/2026.
//

import UIKit

class InvoiceInfoListCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientPhone: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerPhone: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : OrderDetailsModel){
        clientName.text = model.userName
        clientPhone.text = model.userPhone
        providerName.text = model.delegateName
        providerPhone.text = model.delegatePhone
        serviceName.text = "bgfghfth"
        servicePrice.text = "100000000"
    }
}
