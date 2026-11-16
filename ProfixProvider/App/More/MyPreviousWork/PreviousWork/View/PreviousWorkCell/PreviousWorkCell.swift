//
//  PreviousWorkCell.swift
//  Profix
//
//  Created by Haneen on 08/01/2026.
//

import UIKit
import Kingfisher

class PreviousWorkCell: UICollectionViewCell {

    @IBOutlet weak var previousWorkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : Works ){
        previousWorkImage.kf.setImage(with: URL(string: model.image ?? ""),options:  [.transition(.fade(0.3))])
    }
}
