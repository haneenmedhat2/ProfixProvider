//
//  PaymentMethodCell.swift
//  Profix
//
//  Created by Haneen on 19/01/2026.
//

import UIKit
import Kingfisher

class PaymentMethodCell: UITableViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var secTitle: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    
    //MARK: - Properties -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Cell setup -

    func setupCell(model : PaymentMethodModel){
        iconImage.kf.setImage(with: URL(string: model.image ?? ""), placeholder: UIImage(resource: .wallet))
        mainTitle.text = model.name
        secTitle.text = model.desc

        if model.isSelected  {
            containerStackView.backgroundColor = .state
            selectionImg.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            containerStackView.backgroundColor = .white
            selectionImg.image = UIImage(systemName: "circle")
        }
    }
}
