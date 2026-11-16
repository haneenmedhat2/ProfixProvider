//
//  ComplaintImagesView.swift
//  Profix
//
//  Created by Haneen on 28/12/2025.
//

import UIKit

class ComplaintImagesView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var imageUploadView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UILabel!
    
    //MARK: - Properties -
 
    var imagesList: [ComplaintImageItem] = []
    var selectionMode: ImageSelectionMode = .multiple
    
    @IBInspectable var titleTxt : String = "" {
        didSet {
            title.text = titleTxt.localized
        }
    }
   
    //MARK: - Initializer -
   
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "ComplaintImagesView")
        view.frame = self.bounds
        self.addSubview(view)
        initialConfigurations()
    }
    
    func initialConfigurations(){
        configureCollectionView()
        addDashedBorder(to : imageUploadView )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onUploadViewTapped))
        imageUploadView.addGestureRecognizer(tap)
    }
        
    func addDashedBorder(to view: UIView) {
        view.layer.sublayers?.removeAll(where: { $0.name == "DashedBorder" })
        
        let dashedBorder = CAShapeLayer()
        dashedBorder.name = "DashedBorder"
        dashedBorder.strokeColor = UIColor.main.cgColor
        dashedBorder.lineDashPattern = [4, 4]
        dashedBorder.fillColor = nil
        dashedBorder.lineWidth = 3
        
        let cornerRadius = view.layer.cornerRadius
        dashedBorder.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
        dashedBorder.frame = view.bounds
        
        view.layer.addSublayer(dashedBorder)
    }
    
    //MARK: - Actions -
    
    @objc func onUploadViewTapped() {
        let picker = ImagePicker()
        switch selectionMode {

        case .single:
            picker.pickImage { [weak self] image, imageData in
                guard let self = self,
                      let data = imageData else { return }

                // replace existing image
                self.imagesList = [ComplaintImageItem(image: image, data: data)]
                self.collectionView.reloadData()
            }

        case .multiple:
            picker.pickImages { [weak self] images, imagesData in
                guard let self = self else { return }

                let newItems = zip(images, imagesData).map {
                    ComplaintImageItem(image: $0.0, data: $0.1)
                }

                self.imagesList.append(contentsOf: newItems)
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView Configuration -

extension ComplaintImagesView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
        let item = imagesList[indexPath.row]
        cell.setupCell(image: imagesList[indexPath.row].image, index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 82, height: 72)
    }
}

//MARK: - Delelgation -

extension ComplaintImagesView : ComplaintImageCellProtocol{
    func didTapRemove(at index: Int) {
        imagesList.remove(at: index)
        collectionView.reloadData()
    }
}
