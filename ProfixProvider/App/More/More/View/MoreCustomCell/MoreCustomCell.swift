//
//  MoreCustomCell.swift
//  Cleaf
//
//  Created by Haneen on 11/05/2025.
//

import UIKit

class MoreCustomCell: UICollectionViewCell {

    //MARK: - Outlets -

    @IBOutlet weak var moreIcon: UIImageView!
    @IBOutlet weak var moreTitle: UILabel!
    
    //MARK: - Nib File Setup -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : MoreMenuItem) {
        moreIcon.image = UIImage(named: model.icon)
        moreTitle.text = model.title
        moreTitle.textColor = model.fontColor
    }
}
