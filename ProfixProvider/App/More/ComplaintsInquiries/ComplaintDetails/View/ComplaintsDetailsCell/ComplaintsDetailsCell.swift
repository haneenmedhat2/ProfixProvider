//
//  ComplaintsDetailsCell.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import UIKit

class ComplaintsDetailsCell: UITableViewCell {

    //MARK: - Outlets -

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var separatorView: UIView!
    
    //MARK: - Properties -

    var imageList : [ComplaintsImages] = []
    var delegate : ComplaintsDetailsCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    func setupCell(model : ComplaintDetailsRow , isLastCell : Bool){
        mainLabel.text = model.title
        secLabel.text = model.value
        separatorView.isHidden = isLastCell
        imageList = model.images ?? []
        if imageList.isEmpty {
            collectionView.isHidden = true
        }else  {
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
}

extension ComplaintsDetailsCell : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: ComplaintImageCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ComplaintImageCell.self, for: indexPath)
        let item = imageList[indexPath.row]
        cell.closeButton.isHidden = true
        cell.setupCell(url: item.url ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = imageList[indexPath.row]
        delegate?.didSelectImage(url: item.url ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 82, height: 72)
    }
}

protocol ComplaintsDetailsCellProtocol : AnyObject {
    func didSelectImage(url : String)
}
