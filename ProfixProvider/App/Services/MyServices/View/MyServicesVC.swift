//
//  MyServicesVC.swift
//  ProfixProvider
//
//  Created by Haneen on 08/02/2026.
//

import UIKit
import Combine

class MyServicesVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties -
    
    let viewModel : MyServicesVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : MyServicesVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "MyServicesVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
        NotificationCenter.default.addObserver(  self, selector: #selector(refreshData),name: .isServiceChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .isServiceChanged, object: nil)
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration() {
        self.title = "services".localized
        view.isHidden = true
        bindToViewModel()
        configureCollectionView()
        viewModel.getServices()
        setupNotificationButton()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindToViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.servicesPublisher
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                view.isHidden = false
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapAddNewService(_ sender: UIButton) {
        goToAddNewService()
    }
    
    @objc private func refreshData() {
        viewModel.getServices()
    }
}

//MARK: - CollectionView Configurations -

extension MyServicesVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ServicesCell.self)
        collectionView.register(EmptyStateCell.self, forCellWithReuseIdentifier: "EmptyStateCell")

        let layout = UICollectionViewCompositionalLayout { section , environment in
            switch section {
            default:
                return self.servicesSection(isEmpty: self.viewModel.services.isEmpty)
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func servicesSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        let groupHeight: CGFloat = isEmpty ? collectionView.height : 56

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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 8
        
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.services.isEmpty ? 1 : viewModel.services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.services.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCell
            cell.configure(image: .appPlaceholder, message: "no_services".localized)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(with: ServicesCell.self, for: indexPath)
            let item = viewModel.services[indexPath.row]
            cell.setupCell(service: item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.services.indices.contains(indexPath.item) else { return }

        let item = viewModel.services[indexPath.item]
        goToServiceDetails(serviceId: item.id ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        viewModel.services.indices.contains(indexPath.item)
    }
}

//MARK: - Routes -

extension MyServicesVC {
    
    func goToAddNewService(){
        let vc = AddNewServiceVC(viewModel: AddNewServiceVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToServiceDetails(serviceId : Int){
        let vc = ServiceDetailsVC(viewModel: ServiceDetailsVM(serviceId:serviceId))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
