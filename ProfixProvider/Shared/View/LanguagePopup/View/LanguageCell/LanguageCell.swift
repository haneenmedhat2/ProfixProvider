//
//  LanguageCell.swift
//  Profix
//
//  Created by Haneen on 21/12/2025.
//

import UIKit

class LanguageCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var languageIcon: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    
    //MARK: - Properties -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Cell setup -

    func setupCell(model : LanguageModel){
        languageIcon.image = UIImage(named: model.icon)
        languageLabel.text = model.name
        
        if model.isSelected  {
            languageLabel.textColor = .main
            selectionImg.tintColor = .main
            selectionImg.image = UIImage(systemName: "circle.inset.filled")
        } else {
            languageLabel.textColor = .black
            selectionImg.tintColor = .black
            selectionImg.image = UIImage(systemName: "circle")
        }
    }
}
