//
//  HomeVC.swift
//  Profix
//
//  Created by Haneen on 21/12/2025.
//

import UIKit
import Combine

class HomeVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    //MARK: - Properties -
    
    let viewModel : HomeVMProtocol
    private var skeletonView: SkeletonLoadingView?
    private let refreshControl = UIRefreshControl()
    private var sitePhone: String?

    private lazy var callAdminButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .main
        button.tintColor = .white
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCallAdmin), for: .touchUpInside)
        return button
    }()

    private lazy var callAdminLabel: UILabel = {
        let label = UILabel()
        label.text = "technical_support".localized
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .main
        label.textAlignment = .center
        return label
    }()

    private lazy var callAdminContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [callAdminButton, callAdminLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()


    //MARK: - Initializer -
    
    init(viewModel : HomeVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "HomeVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.languageChanged {
            UserDefaults.languageChanged = false
            viewModel.changeLanguageRequest()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.homeRequest()
        NotificationCountManager.shared.refresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        self.title = "home".localized
        configureCollectionView()
        setupRefreshControl()
        bindToViewModel()
        setupNotificationButton()
        viewModel.getSitePhone()
        showSkeletonView()
        setupCallAdminButton()
    }
    
    private func setupCallAdminButton() {
        callAdminContainer.isHidden = true
        view.addSubview(callAdminContainer)

        NSLayoutConstraint.activate([
            callAdminButton.widthAnchor.constraint(equalToConstant: 56),
            callAdminButton.heightAnchor.constraint(equalToConstant: 56),
            callAdminContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            callAdminContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func didTapCallAdmin() {
        guard let phone = sitePhone, !phone.isEmpty else { return }
        let sanitized = phone.replacingOccurrences(of: " ", with: "")
        AppHelper.openUrl("tel://\(sanitized)")
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionview.refreshControl = refreshControl
    }

    private func bindToViewModel() {
          loading(viewModel.isLoadingPublisher)

          viewModel.homePublisher
              .sinkOnMain { [weak self] _ in
                  self?.hideSkeletonView()
                  self?.collectionview.reloadData()
                  self?.refreshControl.endRefreshing()
              }
              .store(in: &cancellables)
        
        viewModel.sitePhonePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] phone in
                guard let self = self else { return }
                self.sitePhone = phone
                self.callAdminContainer.isHidden = phone.isEmpty
            }
            .store(in: &cancellables)

          error(viewModel.errorPublisher)
      }
    
    //MARK: - Actions -
    
    @objc private func didPullToRefresh() {
        viewModel.resetData()
        viewModel.homeRequest()
    }
      
      // MARK: - Skeleton -
    
      private func showSkeletonView() {
          let skeleton = SkeletonLoadingView()
          skeleton.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(skeleton)
          
          NSLayoutConstraint.activate([
              skeleton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              skeleton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              skeleton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              skeleton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
          ])
          
          skeleton.startShimmering()
          skeletonView = skeleton
          collectionview.isHidden = true
      }
      
      private func hideSkeletonView() {
          UIView.animate(withDuration: 0.3, animations: {
              self.skeletonView?.alpha = 0
          }) { _ in
              self.skeletonView?.stopShimmering()
              self.skeletonView?.removeFromSuperview()
              self.skeletonView = nil
              self.collectionview.isHidden = false
          }
      }
  }

//MARK: - CollectionView Configurations -

extension HomeVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    
    func configureCollectionView(){
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(EmptyStateCell.self, forCellWithReuseIdentifier: "EmptyStateCell")
        collectionview.register(BannerSliderCell.self, forCellWithReuseIdentifier: "BannerSliderCell")
        collectionview.register(AvailabilityCell.self, forCellWithReuseIdentifier: AvailabilityCell.reuseIdentifier)
        collectionview.register(cellType: OrderStatisticsCell.self)
        collectionview.register(cellType: NewOrderCell.self)
        collectionview.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: CollectionHeaderView.elementKind,
                                withReuseIdentifier: CollectionHeaderView.headerIdentifier)

        let layout = UICollectionViewCompositionalLayout { section , environment in
            switch section {
            case 0:
                return self.availabilitySection()
            case 1:
                return self.adsSection()
            case 2:
                return self.orderStatisticsSection()
            case 3:
                return self.newOrdersSection(isEmpty: self.viewModel.ordersList.isEmpty)
            default:
                return self.adsSection()
            }
        }
        
        collectionview.setCollectionViewLayout(layout, animated: true)
    }
    
    
    func availabilitySection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(56)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)

        return section
    }

    func adsSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

        return section
    }

    func orderStatisticsSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(65)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(65)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)

        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(35)
                ),
                elementKind: CollectionHeaderView.elementKind,
                alignment: .top
            )
        ]

        return section
    }

    func newOrdersSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        let groupHeight: CGFloat = isEmpty ? 160 : 110

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(groupHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(groupHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
        section.interGroupSpacing = 12

        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                ),
                elementKind: CollectionHeaderView.elementKind,
                alignment: .top
            )
        ]

        return section
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.ads.isEmpty ? 0 : 1
        case 2:
            return viewModel.statistics.count
        case 3:
            return viewModel.ordersList.isEmpty ? 1 :  viewModel.ordersList.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailabilityCell.reuseIdentifier, for: indexPath) as! AvailabilityCell
            cell.configure(isOn: Session.user?.availableForOrders ?? false)
            cell.delegate = self
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerSliderCell", for: indexPath) as! BannerSliderCell
            cell.configure(list: viewModel.ads)
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(with: OrderStatisticsCell.self, for: indexPath)
            let item = viewModel.statistics[indexPath.row]
            cell.setupCell(model: item)
            return cell

        case 3:
            if viewModel.ordersList.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCell
                cell.configure(image: .appPlaceholder, message: "no_new_orders".localized)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(with: NewOrderCell.self, for: indexPath)
                let item = viewModel.ordersList[indexPath.row]
                cell.setupCell(model: item)
                return cell
            }

        default:
            return UICollectionViewCell()
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 3,
              viewModel.ordersList.indices.contains(indexPath.item) else { return }

        let item = viewModel.ordersList[indexPath.item]
        goToOrderDetails(id: item.id ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 3 else { return true }
        return viewModel.ordersList.indices.contains(indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if indexPath.row == viewModel.ordersList.count - 1,
               !viewModel.isLastPage {
                self.viewModel.homeRequest()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        var title = ""
        switch indexPath.section {
        case 2:
            title = "orders_statistics".localized
        case 3:
            title = "new_orders".localized
        default:
            break
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: CollectionHeaderView.elementKind,
            withReuseIdentifier: CollectionHeaderView.headerIdentifier,
            for: indexPath
        ) as! CollectionHeaderView
        
        header.configure(title: title)
        return header
    }
}
//MARK: - Routes -

extension HomeVC {
    func goToOrderDetails(id : Int){
        let vc = OrderDetailsVC(viewModel: OrderDetailsVM(orderId: id ))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}

//MARK: - AvailabilityCellDelegate -

extension HomeVC: AvailabilityCellDelegate {
    func availabilityCell(_ cell: AvailabilityCell, didChangeValue isOn: Bool) {
        viewModel.getAvailability()
    }
}
