//
//  TermsConditionsVC.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import UIKit
import Combine

class TermsConditionsVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var staticPagesView: StaticPagesView!
    
    //MARK: - Properties -
    
    var viewModel : TermsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : TermsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "TermsConditionsVC", bundle: nil)
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
        self.title = "terms_conditions".localized
        view.isHidden = true
        bindViewModel()
        viewModel.termsRequest()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.termsPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                let text = result?.data?.terms ?? ""
                let convertedString = text.htmlToAttributedString
                staticPagesView.textView.attributedText = convertedString
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}
