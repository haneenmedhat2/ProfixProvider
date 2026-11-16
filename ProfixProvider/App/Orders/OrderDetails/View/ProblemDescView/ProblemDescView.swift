//
//  ProblemDescView.swift
//  Profix
//
//  Created by Haneen on 15/01/2026.
//

import UIKit

class ProblemDescView: UIView {

    //MARK: - Outlets -
    
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descView: UIView!
    
    //MARK: - Properites -
     
    var imagesList : [ProblemDescImageType] = []
    weak var delegate: ProblemDescViewDelegate?

    
    //MARK: - Initializer -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
        configureCollectionView()
    }
    
    //MARK: - Nib file configuration -
    
    func viewSetup(){
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
        
    func loadViewFromNib()-> UIView {
        let nib = UINib(nibName: "ProblemDescView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func getDataSource(problemDesc : String ,imageList : [ProblemDescImageType],type :ViewType){
        descView.backgroundColor = type.backgroundColor
        descTextView.text = problemDesc
        imagesList = imageList
        if imageList.isEmpty {
            collectionView.isHidden = true
        }
        collectionView.reloadData()
        
    }
}

//MARK: - Collection View Configurations -

extension ProblemDescView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ComplaintImageCell.self)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ComplaintImageCell.self, for: indexPath)
        cell.closeButton.isHidden = true
        let item = imagesList[indexPath.row]
        
        switch item {
        case .local(let data):
            cell.setupCell(imageData: data)

        case .remote(let remote):
            cell.setupCell(url: remote)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = imagesList[indexPath.row]
        delegate?.didSelectImage(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 82, height: 72)
    }
}

protocol ProblemDescViewDelegate: AnyObject {
    func didSelectImage(_ image: ProblemDescImageType)
}
