//
//  SettingsVC.swift
//  Profix
//
//  Created by Haneen on 22/12/2025.
//

import UIKit
import Combine

class SettingsVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: - Properties -
    
    let viewModel :SettingsVM

    //MARK: - Initializer -
    
    init(viewModel :SettingsVM){
        self.viewModel = viewModel
        super.init(nibName: "SettingsVC", bundle: nil)
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
        self.title = "settings".localized
        configureCollectionView()
        bindToViewModel()
    }
    
    func bindToViewModel() {
        loading(viewModel.isLoadingPublisher)

        viewModel.switchNotificationPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                UserDefaults.isNotify = result?.data?.notify ?? true
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.deleteAccountPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                self.goToLogin()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}
//MARK: - Collection View Configuration -

extension SettingsVC : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
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
            return viewModel.settingsItems.count
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
            let item = viewModel.settingsItems[indexPath.row]
            cell.setupCell(model : item)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(with: LastCell.self, for: indexPath)
            cell.delegate = self
            cell.setupCell(model: .fcm)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let item = viewModel.settingsItems[indexPath.row]
            handleMenuSelection(item)
            
        default:
            break
        }
    }
    
    private func handleMenuSelection(_ item: MoreMenuItem) {
        switch item {
        case .editProfile:
            goToUpdateProfile()
        case .changePhone:
            goToCurrentPassword()
        case .changePassword:
            goToChangePassword()
        case .changeLanguage:
            showLanguagePopup()
        case .deleteAccount:
            showDoubleActionPopup()
        default:
            break
        }
    }
}

//MARK: - Routes -
extension SettingsVC {
    func goToUpdateProfile(){
        let vc = UpdateProfileVC(viewModel: UpdateProfileVM())
        push(vc)
    }
    
    func goToCurrentPassword(){
        let vc = CurrentPasswordVC(viewModel: CurrentPasswordVM())
        push(vc)
    }
    
    func goToChangePassword(){
        let vc = ChangePasswordVC(viewModel: ChangePasswordVM())
        push(vc)
    }
    
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func showDoubleActionPopup(){
        let popup = DoubleActionPopupView()
        popup.appear(sender: self)
        popup.delegate = self
        popup.setupView(type: .deleteAccount)
    }
    
    func goToLogin(){
        Session.isLogin = false
        Session.user = nil
        Session.token  = nil
        UserDefaults.isNotify = true
        
        let loginVC = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: loginVC)
        AppHelper.changeWindowRoot(vc: nav)
    }
}

//MARK: - Delegation -

extension SettingsVC : DoubleActionPopupProtocol , LastCellProtocol{

    func didTapFirstAction() {
        viewModel.deleteAccountRequest()
    }
    
    func onSwitchValueChanged() {
        viewModel.switchNotificationRequest()
    }
}
