//
//  CurrentPasswordVC.swift
//  Profix
//
//  Created by Haneen on 23/12/2025.
//

import UIKit
import Combine

class CurrentPasswordVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var currentPasswordTextField: PasswordTextField!
    
    //MARK: - Properties -
    
    let viewModel : CurrentPasswordVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : CurrentPasswordVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "CurrentPasswordVC", bundle: nil)
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
        self.title = "change_phone_title".localized
        bindViewModel()
    }

    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.currentPasswordPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                if result.data?.check ?? false {
                    goToNewPhone()
                } else  {
                    show(errorMessage: "incorrect_current_password".localized)
                }
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
        let password = currentPasswordTextField.txtField.text
        viewModel.validateInputs(password: password)
    }
}

//MARK: - Routes -
extension CurrentPasswordVC {
    func goToNewPhone(){
        let vc = NewPhoneVC(viewModel: NewPhoneVM())
        push(vc)
    }
}
