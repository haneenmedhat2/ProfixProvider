//
//  CustomerReviewCell.swift
//  Profix
//
//  Created by Haneen on 08/01/2026.
//

import UIKit

class CustomerReviewCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var providerRating: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : Reviews){
        customerName.text = model.userName
        providerRating.text = model.rate
        
        if let comment = model.comment, comment.isEmpty{
            descTextView.text = "no_comment".localized
        } else {
            descTextView.text = model.comment
        }
    }
}
