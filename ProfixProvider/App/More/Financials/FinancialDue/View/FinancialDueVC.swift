//
//  FinancialDueVC.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//

import UIKit
import Combine

class FinancialDueVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newSettlementBtn: MainButton!
    
    //MARK: - Properties -
    
    var viewModel : FinancialDueVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : FinancialDueVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "FinancialDueVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.getSettlements()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        view.isHidden = true
        bindToViewModel()
        configureCollectionView()
    }
    
    func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.financialDuePublisher
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                self.collectionView.reloadData()
                self.newSettlementBtn.isEnabled = !(viewModel.ordersList.isEmpty)
                self.newSettlementBtn.alpha = !(viewModel.ordersList.isEmpty) ? 1 : 0.5
            }
            .store(in: &cancellables)
        
        viewModel.settlementPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result.message)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapNewSettlement(_ sender: UIButton) {
        guard let model = viewModel.financialDue?.totalValues else { return }
        let settlement = Settlement(totalPrice: model.totalPrice?.toDouble(), totalAddedValue: model.totalAddedValue?.toDouble(), totalAppPercentage: model.totalAppPercentage?.toDouble(), totalDue: model.totalDue?.toDouble())
        viewModel.settlementRequest(model: settlement)
    }
}

//MARK: - CollectionView Configurations -

extension FinancialDueVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmptyStateCell.self, forCellWithReuseIdentifier: "EmptyStateCell")
        collectionView.register(cellType: TotalValueView.self)
        collectionView.register(cellType: FinancialBreakDownCell.self)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: CollectionHeaderView.elementKind,
                                withReuseIdentifier: CollectionHeaderView.headerIdentifier)
        
        let layout = UICollectionViewCompositionalLayout { section , environment in
            switch section {
            case 0:
                return self.totalValueSection()
            case 1:
                return self.financialBreakDownSection(isEmpty: self.viewModel.ordersList.isEmpty)
            default:
                return self.totalValueSection()
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
    func financialBreakDownSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        let groupHeight: CGFloat = isEmpty ? 160 : 135

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(groupHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(groupHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 8
        
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: CollectionHeaderView.elementKind, alignment: .top)
        ]
        
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.ordersList.isEmpty ? 1 : viewModel.ordersList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(with: TotalValueView.self, for: indexPath)
            let item = viewModel.financialDue?.totalValues
            cell.setupCell(model: item)
            return cell
            
        case 1:
            if viewModel.ordersList.isEmpty  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCell
                cell.configure(image: .appPlaceholder, message: "no_orders".localized)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(with: FinancialBreakDownCell.self, for: indexPath)
                let item = viewModel.ordersList[indexPath.row]
                cell.setupCell(model: item)
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 1 else { return true }
        return viewModel.ordersList.indices.contains(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let title  = "orders".localized
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: CollectionHeaderView.elementKind,
            withReuseIdentifier: CollectionHeaderView.headerIdentifier,for: indexPath ) as! CollectionHeaderView
        header.configure(title: title ,isBold: true)
        return header
    }
}
