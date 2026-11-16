//
//  PickerListCell.swift
//  ProfixProvider
//
//  Created by Haneen on 26/01/2026.
//

import UIKit

class PickerListCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var containerstackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : SelectionModelPicker , isSelected : Bool){
        itemLabel.text = model.pickerName
        
        if isSelected {
            containerstackView.backgroundColor = .selectionBG
            selectionImage.tintColor = .main
            selectionImage.image = UIImage(systemName: "checkmark.app.fill")
        } else {
            containerstackView.backgroundColor = .textFieldBackground
            selectionImage.tintColor = .lightGray
            selectionImage.image = UIImage(systemName: "square")

        }
        
    }
}
