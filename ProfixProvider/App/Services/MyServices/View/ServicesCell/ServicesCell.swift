//
//  ServicesCell.swift
//  Profix
//
//  Created by Haneen on 07/01/2026.
//

import UIKit

class ServicesCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
   
    //MARK: - Properties -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(service: Services){
        serviceName.text = service.subcategoryName
        servicePrice.text = service.price?.toPrice
    }
}
