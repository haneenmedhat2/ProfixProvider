//
//  MyRatingsVC.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//

import UIKit
import Combine

class MyRatingsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties -
    
    var viewModel : MyRatingsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : MyRatingsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "MyRatingsVC", bundle: nil)
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
        self.title = "my_ratings".localized
        view.isHidden = true
        bindToViewModel()
        configureCollectionView()
        viewModel.getReviews()
    }
    
    func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.reviewsPublisher
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                view.isHidden = false
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}

//MARK: - CollectionView Configurations -

extension MyRatingsVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: CustomerReviewCell.self)
        collectionView.register(EmptyStateCell.self, forCellWithReuseIdentifier: "EmptyStateCell")
        let layout = UICollectionViewCompositionalLayout { section , environment in
            switch section {
            default:
                return self.customerReviewsSection(isEmpty: self.viewModel.reviews.isEmpty)
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func customerReviewsSection(isEmpty : Bool) -> NSCollectionLayoutSection {
        let groupHeight: CGFloat = isEmpty ? collectionView.height : 80

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
        section.interGroupSpacing = 8
 
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviews.isEmpty ? 1 : viewModel.reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.reviews.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCell
            cell.configure(image: .appPlaceholder, message: "no_reviews".localized)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(with: CustomerReviewCell.self, for: indexPath)
            let item = viewModel.reviews[indexPath.row]
            cell.setupCell(model: item)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        viewModel.reviews.indices.contains(indexPath.item)
    }
}
