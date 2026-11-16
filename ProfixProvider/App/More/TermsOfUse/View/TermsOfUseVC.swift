//
//  TermsOfUseVC.swift
//  Profix
//
//  Created by Haneen on 20/01/2026.
//

import UIKit
import Combine

class TermsOfUseVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var staticPagesView: StaticPagesView!
    
    //MARK: - Properties -
    
    var viewModel : TermsOfUseVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : TermsOfUseVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "TermsOfUseVC", bundle: nil)
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
        self.title = "usage_policy".localized
        view.isHidden = true
        bindViewModel()
        viewModel.termsOfUseRequest()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.termsPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                let text = result?.data?.termsOfUse ?? ""
                let convertedString = text.htmlToAttributedString
                staticPagesView.textView.attributedText = convertedString
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}
