//
//  AddNewComplaintVC.swift
//  Profix
//
//  Created by Haneen on 25/12/2025.
//

import UIKit
import Combine

class AddNewComplaintVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var complaintTitle: GeneralTextField!
    @IBOutlet weak var complaintDesc: DropDownTextView!
    @IBOutlet weak var complaintImagesView: ComplaintImagesView!
    
    //MARK: - Properties -
    
    var viewModel : AddNewComplaintsVMProtocol
    var delegate :AddNewComplaintProtocol?

    //MARK: - Initializer -
    
    init(viewModel :AddNewComplaintsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "AddNewComplaintVC", bundle: nil)
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
        self.title = "send_complaint".localized
        bindViewModel()
    }
    
    //MARK: - ViewModel binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.createComplaintPublisher
            .compactMap{ $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.showPopup(title:result.message)
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.show(errorMessage: result.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
  
    //MARK: - Action -

    @IBAction func didTapSend(_ sender: UIButton) {
        let title = complaintTitle.txtField.text
        let desc = complaintDesc.actualText
        viewModel.images = complaintImagesView.imagesList.map{ $0.data }
        viewModel.validateData(title: title, desc: desc)
    }
}

//MARK: - Routes -

extension AddNewComplaintVC {
    func showPopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didAddNewComplaint()
            pop()
        }
    }
}

//MARK: - Delegate Protocol -

protocol AddNewComplaintProtocol : AnyObject {
    func didAddNewComplaint()
}
