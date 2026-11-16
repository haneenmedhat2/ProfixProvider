//
//  CancelReasonCell.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit

class CancelReasonCell: UICollectionViewCell {

    @IBOutlet weak var cancelReasontextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(reason : String){
        cancelReasontextView.text = reason
    }
}
