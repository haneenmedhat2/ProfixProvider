//
//  ActivateNewPhoneVC.swift
//  Profix
//
//  Created by Haneen on 23/12/2025.
//

import UIKit
import Combine


class ActivateNewPhoneVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var verificationView: VerificationView!
    
    //MARK: - Properties -

    var viewModel: ActivateNewPhoneVM
    
    //MARK: - Initializer -

    init(viewModel: ActivateNewPhoneVM) {
        self.viewModel = viewModel
        super.init(nibName: "ActivateNewPhoneVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "change_phone".localized
        verificationView.delegate = self
        bindViewModel()
        viewModel.startCountdown()
        
        guard var viewControllers = navigationController?.viewControllers else { return }
        viewControllers.removeAll { $0 is NewPhoneVC }
        navigationController?.viewControllers = viewControllers
    }
    
    private func bindViewModel() {
        
        loading(viewModel.isLoadingPublisher)
        
        viewModel.remainingTimePublisher
            .sinkOnMain { [weak self] time in
                guard let self = self else { return }
                self.verificationView.updateTimer(time: time)
            }
            .store(in: &cancellables)
        
        viewModel.isResendEnabledPublisher
            .sinkOnMain { [weak self] isEnabled in
                guard let self = self else { return }
                self.verificationView.setResendEnabled(isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] error in
                guard let self = self else { return }
                self.show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.phoneActivationPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self, let _ = result.data else { return }
                self.showLottiePopup(title: result.message)
            }
            .store(in: &cancellables)
        
        viewModel.resendCodePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.show(successMessage: result.message)
                self.viewModel.startCountdown()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}

//MARK: - Routes -
extension ActivateNewPhoneVC {
    
    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            pop()
        }
    }
}

//MARK: - Delegation -

extension ActivateNewPhoneVC: VerificationViewDelegate {
    
    func didTapConfirm(otp: String) {
         viewModel.validateOTP(otp: otp)
    }
    
    func didTapResend() {
        viewModel.resendCodeRequest()
    }
}
