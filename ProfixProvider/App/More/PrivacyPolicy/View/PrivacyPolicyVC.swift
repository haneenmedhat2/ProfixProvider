//
//  PrivacyPolicyVC.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import UIKit
import Combine

class PrivacyPolicyVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var staticPagesView: StaticPagesView!
    
    //MARK: - Properties -
    
    var viewModel : PrivacyPolicyVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : PrivacyPolicyVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "PrivacyPolicyVC", bundle: nil)
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
        self.title = "privacy_policy".localized
        view.isHidden = true
        bindViewModel()
        viewModel.privacyPolicyRequest()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.privacyPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                let text = result?.data?.policy ?? ""
                let convertedString = text.htmlToAttributedString
                staticPagesView.textView.attributedText = convertedString
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}
