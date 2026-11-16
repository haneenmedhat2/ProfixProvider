//
//  OrderCustomViewCell.swift
//  Cleaf
//
//  Created by Haneen on 02/06/2025.
//

import UIKit

class OrderStateViewCell: UICollectionViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    //MARK: - Properties -
    
    //MARK: - Nib File Configuration -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Setup Cell -
  
    func setupCell(orderStatus: OrderStatus){
        cellLabel.text = orderStatus.stringValue
    }
    
    func updateCellSelection(isCellSelected : Bool ){
        if isCellSelected {
            cellContentView.backgroundColor = UIColor.state
            cellLabel.textColor = .main
        } else {
            cellContentView.backgroundColor = .white
            cellLabel.textColor = .black
        }
    }
}
