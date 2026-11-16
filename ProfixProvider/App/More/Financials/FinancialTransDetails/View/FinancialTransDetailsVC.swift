//
//  FinancialTransDetailsVC.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit
import Combine

class FinancialTransDetailsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties -
    
    var viewModel : FinancialDetailsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : FinancialDetailsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "FinancialTransDetailsVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        self.title = "financial_transactions".localized
        view.isHidden = true
        bindToViewModel()
        configureCollectionView()
        viewModel.getFinancialDetails()
    }
    
    func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.financialDetailsPublisher
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}

//MARK: - CollectionView Configurations -

extension FinancialTransDetailsVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: FinancialStatusCell.self)
        collectionView.register(cellType: TotalValueView.self)
        collectionView.register(cellType: CancelReasonCell.self)
        collectionView.register(cellType: TransferImageCell.self)
        collectionView.register(cellType: FinancialBreakDownCell.self)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: CollectionHeaderView.elementKind,
                                withReuseIdentifier: CollectionHeaderView.headerIdentifier)
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch self.viewModel.sections[sectionIndex] {
            case .status:
                return self.financialStatusSection()
            case .totalValue:
                return self.totalValueSection()
            case .cancelReason:
                return self.cancelReasonSection()
            case .transferImage:
                return self.transferImageSection()
            case .breakDown:
                return self.financialBreakDownSection()
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func financialStatusSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(48)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(48)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        return section
    }
    
    
    func totalValueSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(165)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(165)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        return section
    }
    
    func cancelReasonSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: .init( widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)),elementKind: CollectionHeaderView.elementKind, alignment: .top)

        header.contentInsets = NSDirectionalEdgeInsets( top: 0,leading: 0,bottom: 8,trailing: 0 )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func transferImageSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(135)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(145)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: .init( widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)),elementKind: CollectionHeaderView.elementKind, alignment: .top)

        header.contentInsets = NSDirectionalEdgeInsets( top: 0,leading: 0,bottom: 8,trailing: 0 )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    func financialBreakDownSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(135)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        section.interGroupSpacing = 8
        
        let header = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: .init( widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)),elementKind: CollectionHeaderView.elementKind, alignment: .top)

        header.contentInsets = NSDirectionalEdgeInsets( top: 0,leading: 0,bottom: 8,trailing: 0 )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .status, .totalValue, .cancelReason, .transferImage:
            return 1
        case .breakDown:
            return viewModel.settlements.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch viewModel.sections[indexPath.section] {
            
        case .status:
            let cell = collectionView.dequeueReusableCell(with: FinancialStatusCell.self, for: indexPath)
            if let item = viewModel.financialDetails?.totalValues?.getFinancialStatusModel() {
                cell.setupCell(model: item)
            }
            return cell
            
        case .totalValue:
            let cell = collectionView.dequeueReusableCell(with: TotalValueView.self, for: indexPath)
            cell.setupCell(model: viewModel.financialDetails?.totalValues)
            return cell
            
        case .cancelReason:
            let cell = collectionView.dequeueReusableCell(with: CancelReasonCell.self, for: indexPath)
            cell.setupCell(reason: viewModel.financialDetails?.totalValues?.refuseReason ?? "")
            return cell
            
        case .transferImage:
            let cell = collectionView.dequeueReusableCell(with: TransferImageCell.self, for: indexPath)
            cell.setupCell(image: viewModel.financialDetails?.totalValues?.image ?? "")
            return cell
            
        case .breakDown:
            let cell = collectionView.dequeueReusableCell(with: FinancialBreakDownCell.self, for: indexPath)
            cell.setupCell(model: viewModel.settlements[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .transferImage:
           let image = viewModel.financialDetails?.totalValues?.image ?? ""
           let vc = ImageViewerVC(viewModel: ImageViewerVM(image: .remote(image)))
            vc.appear(sender: self)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var title = "orders".localized
        
        switch viewModel.sections[indexPath.section] {
           case .cancelReason:
               title = "rejection_reason".localized
           case .transferImage:
               title = "transfer_receipt_image".localized
           case .breakDown:
               title = "orders".localized
           default:
               title = ""
           }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: CollectionHeaderView.elementKind,withReuseIdentifier: CollectionHeaderView.headerIdentifier,for: indexPath ) as! CollectionHeaderView
        header.configure(title: title, isBold: true)
        return header
    }
}

