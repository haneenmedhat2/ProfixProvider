//
//  ComplaintImageCell.swift
//  Profix
//
//  Created by Haneen on 28/12/2025.
//

import UIKit
import Kingfisher

class ComplaintImageCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - Properties -

    var currentIndex : Int = 0
    var delegate : ComplaintImageCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Cell Setup -
    
    func setupCell(image : UIImage, index : Int){
        cellImage.image = image
        currentIndex = index
    }
    
    func setupCell(url : String){
        cellImage.kf.setImage(with: URL(string: url))
    }
    
    func setupCell(imageData: Data) {
        if let image = UIImage(data: imageData) {
            cellImage.image = image
        } else {
            cellImage.image = UIImage(resource: .complaintsPlaceholder)
        }
    }

    //MARK: - Actions -
    
    @IBAction func didTapRemove(_ sender: UIButton) {
        delegate?.didTapRemove(at: currentIndex)
    }
}

//MARK: - Delegate Protocol -

protocol ComplaintImageCellProtocol: AnyObject {
    func didTapRemove(at index: Int)
}
