//
//  CreateInvoiceVC.swift
//  ProfixProvider
//
//  Created by Haneen on 10/02/2026.
//

import UIKit
import Combine

class CreateInvoiceVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var serviceTextField: GeneralTextField!
    @IBOutlet weak var servicePriceTextField: GeneralTextField!
    
    //MARK: - Properties -
    
    var viewModel : CreateInvoiceVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : CreateInvoiceVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "CreateInvoiceVC", bundle: nil)
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
        self.title = "issue_invoice".localized
        bindViewModel()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        viewModel.createInvoicePublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.showLottiePopup(title: result.message)
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
    
    //MARK: - Action -
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        let serviceName = serviceTextField.txtField.text
        let servicePrice = servicePriceTextField.txtField.text
        viewModel.validateUserData(service: serviceName, price: servicePrice)
    }
}

//MARK: - Routes -

extension CreateInvoiceVC {
    
    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title, type: .normal)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .isOrderChanged, object: nil)
            pop()
        }
    }
}
