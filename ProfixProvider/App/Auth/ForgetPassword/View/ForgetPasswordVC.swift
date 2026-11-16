//
//  ForgetPasswordVC.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import UIKit
import Combine
class ForgetPasswordVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var phoneTextField: PhoneTextField!
    
    //MARK: - Properties -
    
    let viewModel : ForgetPasswordVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : ForgetPasswordVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ForgetPasswordVC", bundle: nil)
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
        self.title = "Forgot_password".localized
        bindToViewModel()
    }
    
    func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.forgetPasswordPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                guard let model = result?.data else { return }
                self.show(successMessage: result?.message ?? "")
                self.goToVerification(model: model)
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
    
    @IBAction func didTapConfirms(_ sender: UIButton) {
        let phone = phoneTextField.txtField.text
        viewModel.validatePhone(phone: phone)
    }
}

//MARK: - Routes -

extension ForgetPasswordVC {
    func goToVerification(model : LoginResponse){
        let vc = VerificationVC(viewModel: VerificationVM(model: model, flow: .resetPassword))
        push(vc)
    }
}
