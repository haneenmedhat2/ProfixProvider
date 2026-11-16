//
//  AboutUsVC.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import UIKit
import Combine

class AboutUsVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var staticPagesView: StaticPagesView!
    
    //MARK: - Properties -
    
    var viewModel : AboutUsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : AboutUsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "AboutUsVC", bundle: nil)
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
        self.title = "about_app".localized
        view.isHidden = true
        bindViewModel()
        viewModel.aboutUsRequest()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.aboutUsPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                let text = result?.data?.aboutUs ?? ""
                let convertedString = text.htmlToAttributedString
                staticPagesView.textView.attributedText = convertedString
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}
