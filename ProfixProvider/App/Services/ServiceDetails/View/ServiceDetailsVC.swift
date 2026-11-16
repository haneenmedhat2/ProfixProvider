//
//  ServiceDetailsVC.swift
//  ProfixProvider
//
//  Created by Haneen on 08/02/2026.
//

import UIKit
import Combine

class ServiceDetailsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    
    //MARK: - Properties -
    
    let viewModel : ServiceDetailsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : ServiceDetailsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ServiceDetailsVC", bundle: nil)
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
        self.title = "service_details".localized
        bindViewModel()
        viewModel.getServiceDetails()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.serviceDetailsPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                guard let result = result else { return }
                self.setupData(model : result)
            }
            .store(in: &cancellables)
        
        viewModel.deleteServicePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.showPopup(title: result.message)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    func setupData(model : Services){
        mainCategoryLabel.text = model.categoryName
        serviceLabel.text = model.subcategoryName
        servicePriceLabel.text = model.price?.toPrice
        
        if let description = model.description , !description.trimWhiteSpace().isEmpty{
            descriptionTextView.text = description
        } else {
            descriptionTextView.text = "no_service_description".localized
        }
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        if viewModel.serviceDetails?.canEditDelete ?? true {
            goToUpateService()
        } else {
            showAlertPopup(title: "cannot_edit_booked_service".localized)
        }
    }
    
    
    @IBAction func didTapDelete(_ sender: UIButton) {
        if viewModel.serviceDetails?.canEditDelete ?? true {
            showDoubleActionPopup()
        } else {
            showAlertPopup(title: "cannot_delete_booked_service".localized)
        }
    }
}

//MARK: - Routes -

extension ServiceDetailsVC {
    func showPopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .isServiceChanged, object: nil)
            popToRoot()
        }
    }
    
    func goToUpateService(){
        guard let model = viewModel.serviceDetails else { return }
        let vc = UpdateServiceVC(viewModel: UpdateServiceVM(serviceDetails: model))
        push(vc)
    }
    
    func showDoubleActionPopup(){
        let popup = DoubleActionPopupView()
        popup.appear(sender: self)
        popup.delegate = self
        popup.setupView(type: .deleteService)
    }
    
    func showAlertPopup(title : String){
        let popup = AlertPopup()
        popup.appear(sender: self)
        popup.setupView(title : title )
    }
    
}

//MARK: - Delegation -

extension ServiceDetailsVC : DoubleActionPopupProtocol {
    
    func didTapFirstAction() {
        viewModel.deleteServiceRequest()
    }
}
