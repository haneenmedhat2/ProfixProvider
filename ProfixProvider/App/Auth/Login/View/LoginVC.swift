//
//  LoginVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit
import Combine

class LoginVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var languageBtn: IconTextGeneralButton!
    
    //MARK: - Properties -
    
    let viewModel : LoginVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : LoginVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "LoginVC", bundle: nil)
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
        self.title = "login".localized
        bindViewModel()
        requestNotifications()

        languageBtn.onTap = { [weak self] in
            guard let self else { return }
            self.showLanguagePopup()
        }
    }

    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.routePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] route in
                guard let self = self else { return }
                self.handleRoute(route)
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
    
    private func requestNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
    }
    
    //MARK: - Action -
    
    @IBAction func didTapForgetPassword(_ sender: UIButton) {
        goToForgetPassword()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        let phone = phoneTextField.txtField.text
        let password = passwordTextField.txtField.text
        viewModel.validateInputs(model: LoginModel(phone: phone, password: password))
    }
    
    @IBAction func didTapCreateAccount(_ sender: UIButton) {
        goToSignup()
    }
}

//MARK: - Routes -

extension LoginVC {
    
    private func handleRoute(_ route: LoginRoute) {
        
        switch route {
            
        case .verification(let model):
            goToVerification(model: model)
            
        case .pendingApproval(msg: let msg):
            show(errorMessage: msg)
            
        case .refused(msg: let msg):
            show(errorMessage: msg)

        case .home:
            goToHome()
            
        case .completeProfile:
            goToPreviousWork()
        }
    }
    
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func goToSignup(){
        let vc = SignupVC(viewModel: SignupVM())
        push(vc)
    }
    
    func goToForgetPassword(){
        let vc = ForgetPasswordVC(viewModel: ForgetPasswordVM())
        push(vc)
    }
    
    func goToHome() {
        UserDefaults.isLogin = true
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    func goToPreviousWork(){
        let vc = PreviousWorksVC()
        let nav  = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
    
    func goToVerification(model : LoginResponse ){
        let vc = VerificationVC(viewModel: VerificationVM( model: model, flow: .signup))
        push(vc)
    }
}
