//
//  AddNewWorkVC.swift
//  ProfixProvider
//
//  Created by Haneen on 27/01/2026.
//

import UIKit
import Combine
import Kingfisher

class AddNewWorkVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var imagesView: ComplaintImagesView!
    @IBOutlet weak var categoryField: PickerFieldView!
    
    //MARK: - Properties -
    
    var viewModel : AddNewWorkVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel :AddNewWorkVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "AddNewWorkVC", bundle: nil)
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
        self.title = viewModel.mode.title
        imagesView.selectionMode = .single
        categoryField.delegate = self
        categoryField.isHidden = viewModel.mode == .updateItem
        categoryField.icon = UIImage(named: "construction")
        categoryField.txtField.text = viewModel.selectedCategory?.pickerName
        bindViewModel()
        prefillExistingImage()
    }

    private func prefillExistingImage() {
        guard let imagePath = viewModel.existingWork?.image,
              let url = URL(string: imagePath) else { return }
        imagesView.isUserInteractionEnabled = false
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.imagesView.isUserInteractionEnabled = true
                switch result {
                case .success(let value):
                    guard let data = value.image.jpegData(compressionQuality: 0.9) else { return }
                    self.imagesView.imagesList = [ComplaintImageItem(
                        image: value.image,
                        data: data
                    )]
                    self.imagesView.collectionView.reloadData()
                case .failure(let error):
                    self.show(errorMessage: error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - ViewModel binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)

        viewModel.categoriesPublisher
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                self?.showCategoryPicker()
            }
            .store(in: &cancellables)
        
        viewModel.addWorkPublisher
            .compactMap{ $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.showLottiePopup(title: result.message)
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.show(errorMessage: result.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapSend(_ sender: UIButton) {
        viewModel.validateImage(model: AddNewWorkModel(
            image: imagesView.imagesList.first?.data,
            categoryId: viewModel.selectedCategory?.pickerId
        ))
    }
}

extension AddNewWorkVC: PickerFieldViewDelegate {
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        if viewModel.categoriesList.isEmpty {
            viewModel.getCategories()
        } else {
            showCategoryPicker()
        }
    }

    private func showCategoryPicker() {
        let popup = PickerListPopup()
        popup.allowMultipleSelection = false
        popup.pickerList = viewModel.categoriesList
        popup.selectedItem = viewModel.selectedCategory
        popup.onItemSelected = { [weak self] item in
            self?.viewModel.selectedCategory = item
            self?.categoryField.txtField.text = item?.pickerName
        }
        popup.appear(sender: self)
    }
}

//MARK: - Routes -

extension AddNewWorkVC {
    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title, type: .normal)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            switch self.viewModel.mode {
            case .completeInfo:
                self.goToHome()
            case .newItem:
                pop()
            case .updateItem:
                goToMyServices()
            }
        }
    }
    
    func goToHome() {
        Session.isLogin = true
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    func goToMyServices(){
        NotificationCenter.default.post(name: .isWorChanged, object: nil)
        guard var viewControllers = navigationController?.viewControllers else { return }
        viewControllers.removeAll { $0 is WorkDetailsVC }
        navigationController?.viewControllers = viewControllers
        pop()
    
    }
}
