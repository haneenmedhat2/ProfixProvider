//
//  OrderCustomView.swift
//  Cleaf
//
//  Created by Haneen on 02/06/2025.
//

import UIKit

class OrderStateView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properite -
    
    var selectedIndex : IndexPath = IndexPath(item: 0, section: 0)
    var orderStatus: [OrderStatus] = []
    var delegate : OrderStateViewDelegate?
    
    //MARK: - Initializer -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        setupCollectionView()
    }
    
    //MARK: - Nib File Configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "OrderStateView")
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func getCollectionViewDataSource(collectionArray : [OrderStatus]){
        orderStatus = collectionArray
        collectionView.reloadData()
    }
}

//MARK: - Collection View Setup -
extension OrderStateView:
    UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: OrderStateViewCell.self, bundle: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: OrderStateViewCell.self, for: indexPath)
        let isCellSelected = indexPath == selectedIndex
        
        cell.setupCell(orderStatus : orderStatus[indexPath.item])
        cell.updateCellSelection(isCellSelected: isCellSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        delegate?.didSelectItem(at: orderStatus[indexPath.item])
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (Int(collectionView.frame.size.width)) / orderStatus.count
        return CGSize(width: size, height: 52 )
    }
}

//MARK: - Selection Protocol -

protocol OrderStateViewDelegate: AnyObject {
    func didSelectItem(at orderStatus: OrderStatus)
}
