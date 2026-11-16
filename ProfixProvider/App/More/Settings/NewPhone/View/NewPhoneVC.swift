//
//  NewPhoneVC.swift
//  Profix
//
//  Created by Haneen on 23/12/2025.
//

import UIKit
import Combine 

class NewPhoneVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var phoneTextField: PhoneTextField!
    
    //MARK: - Properties -
    
    let viewModel : NewPhoneVM
    
    //MARK: - Initializer -
    
    init(viewModel : NewPhoneVM){
        self.viewModel = viewModel
        super.init(nibName: "NewPhoneVC", bundle: nil)
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
        
        guard var viewControllers = navigationController?.viewControllers else { return }
        viewControllers.removeAll { $0 is CurrentPasswordVC }
        navigationController?.viewControllers = viewControllers
    }

    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.$newPhone
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result.message)
                goToActivateNewPhone()
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
        let newPhone = phoneTextField.txtField.text
        viewModel.validateInputs(phone: newPhone)
    }
}

//MARK: - Routes -
extension NewPhoneVC {
    
    func goToActivateNewPhone(){
        let vc = ActivateNewPhoneVC(viewModel: ActivateNewPhoneVM(phone: phoneTextField.txtField.text ?? ""))
        push(vc)
    }
}
    
