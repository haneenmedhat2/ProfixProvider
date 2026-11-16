//
//  DropDownViewCell.swift
//  Waraqa
//
//  Created by Haneen on 05/08/2025.
//

import UIKit

class DropDownViewCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var cellLabel: UILabel!
    
    //MARK: - Nib File Configuration -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(title: String, cellBackgroundColor : UIColor ){
        cellLabel.text = title
        self.backgroundColor = cellBackgroundColor
    }
}
