//
//  ContactUsVC.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import UIKit
import Combine

class ContactUsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var messageBodyTextView: DropDownTextView!
    @IBOutlet weak var siteLabel: UITextView!

    //MARK: - Properties -
    
    let viewModel : ContactUsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : ContactUsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ContactUsVC", bundle: nil)
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
        self.title = "contact_us".localized
        bindViewModel()
        configureSiteLabel()
        viewModel.getSitePhone()
    }
    
    private func configureSiteLabel() {
        siteLabel.isEditable = false
        siteLabel.isScrollEnabled = false
        siteLabel.isSelectable = true
        siteLabel.dataDetectorTypes = .phoneNumber
        siteLabel.textContainerInset = .zero
        siteLabel.textContainer.lineFragmentPadding = 0
    }

    
    //MARK: - Action -
    
    @IBAction func didTapSend(_ sender: UIButton) {
        let message = messageBodyTextView.textView.text
        viewModel.validateInputs(model: ContactUsModel( message: message))
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.contactUsPublisher
            .compactMap{ $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.showPopup(title: result.message)
            }
            .store(in: &cancellables)

        viewModel.sitePhonePublisher
            .compactMap{ $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.siteLabel.text = result.data?.sitePhone
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

extension ContactUsVC {
    func showPopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            pop()
        }
    }
}
