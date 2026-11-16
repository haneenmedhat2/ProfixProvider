//
//  MoreVC.swift
//  Profix
//
//  Created by Haneen on 21/12/2025.
//

import UIKit
import Combine

class MoreVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: - Properties -
    
    let viewModel : MoreVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : MoreVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "MoreVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
        bindViewModel()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        self.title = "more".localized
        configureCollectionView()
        setupNotificationButton()
    }
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        viewModel.signout
            .compactMap { $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.goToSplashScreen()
            }.store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}
//MARK: - Collection View Configuration -

extension MoreVC : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func AllCellsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(110)
        )
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        return section
    }
    
    func lastCellSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(48)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
        section.interGroupSpacing = 12
        return section
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: MoreCustomCell.self)
        collectionView.register(cellType: LastCell.self)
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.AllCellsSection()
            case 1:
                return self.lastCellSection()
            default:
                return nil
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.menuItems.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(with: MoreCustomCell.self, for: indexPath)
            let item = viewModel.menuItems[indexPath.row]
            cell.setupCell(model : item)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(with: LastCell.self, for: indexPath)
            cell.setupCell(model: .logout)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let item = viewModel.menuItems[indexPath.row]
            handleMenuSelection(item)
        case 1:
            showDoubleActionPopup()
        default:
            break
        }
    }
    
    private func handleMenuSelection(_ item: MoreMenuItem) {
        switch item {
        case .profile:
            goToProfile()
        case .settings:
            goToSettigns()
        case .myPreviousWork:
            goToPreviousWork()
        case .myRattings:
            goToMyRatings()
        case .myAppointments:
            goToMyAppointments()
        case .financialTransactions:
            goToFinancial()
        case .aboutUs:
            goToAboutUs()
        case .usagePolicy:
            goToUsagePolicy()
        case .privacyPolicy:
            goToPrivacyPolicy()
        case .termsAndConditions:
            goToTermsAndConditions()
        case .complaints:
            goToComplaints()
        case .rateUs:
            goToRateUs()
        case .contactUs:
            goToContactUs()
        default:
            break
        }
    }
}

//MARK: - Routes -

extension MoreVC {
    func goToProfile(){
        let vc =  ProfileVC(viewModel: ProfileVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToSettigns(){
        let vc = SettingsVC(viewModel: SettingsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToPreviousWork(){
        let vc = MyPreviousWorkVC(viewModel: MyPreviousWorkVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToMyRatings(){
        let vc = MyRatingsVC(viewModel: MyRatingsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToMyAppointments() {
        let vc = MyAppointmentsVC(viewModel: MyAppointmentsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }

    func goToFinancial(){
        let vc = FinancialTransVC(viewModel: FinancialTransVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }

    func goToAboutUs(){
        let vc = AboutUsVC(viewModel: AboutUsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToUsagePolicy(){
        let vc = TermsOfUseVC(viewModel: TermsOfUseVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToPrivacyPolicy(){
        let vc = PrivacyPolicyVC(viewModel: PrivacyPolicyVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToTermsAndConditions(){
        let vc = TermsConditionsVC(viewModel: TermsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToComplaints(){
        let vc = ComplaintsVC(viewModel: ComplaintsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToRateUs(){
        let appID = "6759157615"
        guard let storeURL = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
              let webURL = URL(string: "https://apps.apple.com/app/id\(appID)") else { return }

        UIApplication.shared.open(storeURL, options: [:]) { opened in
            guard !opened else { return }
            DispatchQueue.main.async {
                UIApplication.shared.open(webURL, options: [:])
            }
        }
    }
    
    func goToContactUs(){
        let vc = ContactUsVC(viewModel: ContactUsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToSplashScreen(){
        Session.isLogin = false
        Session.user = nil
        Session.token  = nil
        UserDefaults.isNotify = true
        
        let splashVC = SplashVC()
        AppHelper.changeWindowRoot(vc: splashVC)
    }
    
    func showDoubleActionPopup(){
        let popup = DoubleActionPopupView()
        popup.appear(sender: self)
        popup.delegate = self
        popup.setupView(type: .signout)
    }
    
    func goToLogin(){
        let vc = LoginVC(viewModel: LoginVM())
        let nav  = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
}

//MARK: - Delegation -

extension MoreVC : DoubleActionPopupProtocol{
    func didTapFirstAction() {
        viewModel.signoutRequest()
    }
}
