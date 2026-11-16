//
//  TransferImageCell.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit
import Kingfisher

class TransferImageCell: UICollectionViewCell {
    
    @IBOutlet weak var transferImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(image: String){
        transferImage.kf.setImage(with: URL(string: image))
    }

}
