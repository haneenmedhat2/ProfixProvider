//
//  VerificationVC.swift
//  Esterad
//
//  Created by Haneen on 19/10/2025.
//

import UIKit
import Combine
import CoreLocation

class VerificationVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var verificationView: VerificationView!
    
    //MARK: - Properties -
    
    var viewModel : VerificationVMProtocol

    //MARK: - Initializer -
    
    init(viewModel : VerificationVMProtocol, ){
        self.viewModel = viewModel
        super.init(nibName: "VerificationVC", bundle: nil)
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
        self.title = viewModel.flow.title
        verificationView.delegate = self
        bindViewModel()
        viewModel.startCountdown()
    }

    //MARK: - View Model Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.verificationPublisher
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                guard let result = result else { return }
                self.handleAction(response : result)
            }
            .store(in: &cancellables)
        
        viewModel.remainingTimePublisher
            .sinkOnMain{ [weak self] time in
                guard let self = self else { return }
                self.verificationView.updateTimer(time: time)
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.isResendEnabledPublisher
            .sinkOnMain{ [weak self] isEnabled in
                guard let self = self else { return }
                self.verificationView.setResendEnabled(isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.resendCodePublisher
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.show(successMessage: result?.message ?? "")
                viewModel.startCountdown()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    func handleAction(response : BaseResponse<String>){
        switch viewModel.flow {
        case .signup:
            viewModel.model.user.approve == .accept ?  goToHome() : showLottiePopup(title: response.message)

        case .resetPassword:
            goToResetPassword(userToken: viewModel.model.token ?? "")
        }
    }
}

//MARK: - Routes -

extension VerificationVC {
    
    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title, type: .normal)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            self.goToLogin()
        }
    }
    
    func goToResetPassword(userToken : String){
        let vc = ResetPasswordVC(viewModel: ResetPasswordVM(userToken: userToken))
        push(vc)
    }
    
    func goToLogin(){
        let vc = LoginVC(viewModel: LoginVM())
        let nav  = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
    
    func goToHome() {
        UserDefaults.isLogin = true
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
}

//MARK: - Delegation -

extension VerificationVC: VerificationViewDelegate {
    
    func didTapConfirm(otp: String) {
         viewModel.validateOTP(otp: otp)
    }
    
    func didTapResend() {
        viewModel.resendCodeRequest()
    }
}
