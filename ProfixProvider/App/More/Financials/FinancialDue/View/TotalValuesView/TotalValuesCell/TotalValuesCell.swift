//
//  TotalValuesCell.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//

import UIKit

class TotalValuesCell: UITableViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : OrderDataModel, isLast : Bool){
        keyLabel.text = model.title
        valueLabel.text = model.value?.toPrice

        
        if isLast {
            containerStackView.backgroundColor = .state
            keyLabel.textColor = .black
            keyLabel.font = .appFont(size: 13, weight: .medium)
            valueLabel.font = .appFont(size: 13, weight: .medium)


        } else {
            containerStackView.backgroundColor = .white
            keyLabel.textColor = .hint
            keyLabel.font = .appFont(size: 14, weight: .light)
            valueLabel.font = .appFont(size: 14, weight: .light)
        }
    }
}
