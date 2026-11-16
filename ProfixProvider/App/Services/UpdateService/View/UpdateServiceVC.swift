//
//  UpdateServiceVC.swift
//  ProfixProvider
//
//  Created by Haneen on 09/02/2026.
//

import UIKit
import Combine

class UpdateServiceVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var mainCategoryTextField: PickerFieldView!
    @IBOutlet weak var serviceTextField: PickerFieldView!
    @IBOutlet weak var servicePriceTextField: GeneralTextField!
    @IBOutlet weak var serviceDescTextView: DropDownTextView!
    
    //MARK: - Properties -
    
    var viewModel : UpdateServiceVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : UpdateServiceVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "UpdateServiceVC", bundle: nil)
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
    
    func initialConfiguration() {
        self.title = "edit_service".localized
        serviceTextField.delegate = self
        mainCategoryTextField.delegate = self
        bindViewModel()
        setupData()
    }
    
    func setupData(){
        mainCategoryTextField.txtField.text = viewModel.serviceDetails.categoryName
        serviceTextField.txtField.text = viewModel.serviceDetails.subcategoryName
        servicePriceTextField.txtField.text = viewModel.serviceDetails.price
        serviceDescTextView.setText(viewModel.serviceDetails.description ?? "" )
        
        viewModel.selectedCategories = Categories(id: viewModel.serviceDetails.categoryId, name: viewModel.serviceDetails.categoryName, slug: nil, image: nibName, status: "active")
        viewModel.selectedSubcategory = SubCategoryModel(id: viewModel.serviceDetails.subcategoryId, name: viewModel.serviceDetails.subcategoryName, image: nil)
        
    }
    
    //MARK: - Action -
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        let model = AddNewServiceModel(categoryId: viewModel.selectedCategories?.pickerId, subcategoryId: viewModel.selectedSubcategory?.pickerId, price: servicePriceTextField.txtField.text, decription: serviceDescTextView.actualText, serviceId: viewModel.serviceDetails.id)
        
        viewModel.validateUserData(model: model)
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        viewModel.updateServicePublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.showLottiePopup(title: result.message)
            }
            .store(in: &cancellables)
        
        viewModel.categoriesPublisher
            .dropFirst()
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                self.showPickerPopup()
            }
            .store(in: &cancellables)
      
        viewModel.subcategoriesPublisher
            .dropFirst()
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                self.showPickerPopup()
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}

//MARK: - Routes -

extension UpdateServiceVC {
    func showPickerPopup() {
        let popup = PickerListPopup()
        switch viewModel.currentPickerType {
            
        case .service:
            popup.allowMultipleSelection = false
            popup.pickerList = viewModel.subcategoriesList
            popup.selectedItem = viewModel.selectedSubcategory
            popup.onItemSelected = { [weak self] item in
                guard let self else { return }
                self.viewModel.selectedSubcategory = item
                self.serviceTextField.txtField.text = item?.pickerName
            }
            
        case .category:
            popup.allowMultipleSelection = false
            popup.pickerList = viewModel.categoriesList
            popup.selectedItem = viewModel.selectedCategories
            popup.onItemSelected = { [weak self] item in
                guard let self else { return }
                self.viewModel.selectedCategories = item
                self.mainCategoryTextField.txtField.text = item?.pickerName
                
                self.viewModel.selectedSubcategory = nil
                self.serviceTextField.txtField.text = nil
            }
            
        default:
            return
        }
        popup.appear(sender: self)
    }
    
    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title, type: .normal)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .isServiceChanged, object: nil)
            popToRoot()
        }
    }
}

//MARK: - Delegate Confirmation -

extension UpdateServiceVC : PickerFieldViewDelegate {
    
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        
        if view === serviceTextField {
            viewModel.currentPickerType = .service
            if (viewModel.selectedCategories) != nil {
                if viewModel.subcategoriesList.isEmpty {
                    viewModel.subcategoryRequest()
                } else {
                    showPickerPopup()
                }
            } else {
                show(errorMessage: "Please choose main category first".localized)
            }
            
        } else if view === mainCategoryTextField {
            viewModel.currentPickerType = .category
            
            if viewModel.categoriesList.isEmpty {
                viewModel.getCategories()
            } else {
                showPickerPopup()
            }
        }
    }
}

