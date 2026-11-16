//
//  BillView.swift
//  Profix
//
//  Created by Haneen on 19/01/2026.
//

import UIKit

class BillView: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properites -
    
    //var delegate : PaymentAlertPopupProtocol?
    var model : OrderDetailsModel
    
    //MARK: - Initializer  -
    
    init(model : OrderDetailsModel) {
        self.model = model
        super.init(nibName: "BillView", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configureCollectionView()
    }
    
    //MARK: - View Configuration -
    
    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor  = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        contentView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackView))
        backView.addGestureRecognizer(tap)
    }
    
    func appear(sender:UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false){
                //self.delegate?.didTapConfirm()
            }
            self.removeFromParent()
        }
    }
  
    
    //MARK: - Action -
    
    @objc func didTapBackView(){
        hide()
    }

}

//MARK: - CollectionView Configuration -
extension BillView : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: InvoiceHeaderCell.self)
        collectionView.register(cellType: InvoiceInfoListCell.self)
        collectionView.register(cellType: InvoiceSummaryCell.self)
        collectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewLayout {

        UICollectionViewCompositionalLayout { sectionIndex, _ in

            switch InvoiceSection(rawValue: sectionIndex) {

            case .header:
                return self.fullWidthEstimated(height: 280)

            case .infoList:
                return self.fullWidthEstimated(height: 240)

            case .summary:
                return self.fullWidthEstimated(height: 300)

            default:
                return nil
            }
        }
    }
    
    func fullWidthEstimated(height: CGFloat)
    -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(height)
            )
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(height)
            ),
            subitems: [item]
        )

        return NSCollectionLayoutSection(group: group)
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let section = InvoiceSection(rawValue: indexPath.section) else {
            return UICollectionViewCell() }

        switch section {

        case .header:
            let cell = collectionView.dequeueReusableCell(with: InvoiceHeaderCell.self,for: indexPath)
            cell.setupCell(model: model)
            return cell

        case .infoList:
            let cell = collectionView.dequeueReusableCell(with: InvoiceInfoListCell.self, for: indexPath)
            cell.setupCell(model: model)
            return cell

        case .summary:
            let cell = collectionView.dequeueReusableCell(with: InvoiceSummaryCell.self,for: indexPath)
            cell.setupCell(model: model)
            return cell
        }
    }
}

//MARK: - PaymentAlertPopup Protocol -

//protocol PaymentAlertPopupProtocol : AnyObject {
//   func didTapConfirm()
//}
