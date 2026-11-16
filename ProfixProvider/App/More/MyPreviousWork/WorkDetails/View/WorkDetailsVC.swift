//
//  WorkDetailsVC.swift
//  ProfixProvider
//
//  Created by Haneen on 05/02/2026.
//

import UIKit
import Combine
import Kingfisher

class WorkDetailsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    //MARK: - Properties -
    
    var viewModel : WorkDetailsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : WorkDetailsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "WorkDetailsVC", bundle: nil)
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
        self.title = "work_details".localized
        view.isHidden = true
        bindToViewModel()
        viewModel.getWorkDetailsRequest()
        
        workImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAddImage))
        workImage.addGestureRecognizer(tap)
    }
    
    func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.workDetailsPublisher
            .compactMap { $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                self.workImage.kf.setImage(with:URL(string: result.image ?? ""),options: [.transition(.fade(0.3))])
                self.categoryLabel.text = "\("main_category".localized): \(result.categoryName ?? "")"
                self.categoryLabel.isHidden = result.categoryName?.isEmpty != false
            }
            .store(in: &cancellables)
        
        viewModel.deleteWorkPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.showLottiePopup(title: result.message)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapEdit(_ sender: UIButton) {
        goToAddNewWork()
    }
    
    @IBAction func didTapDelete(_ sender: UIButton) {
        showDoubleActionPopup()
    }
    
    @objc func didTapAddImage(){
        goToImageViewer()
    }
}
//MARK: - Routes -

extension WorkDetailsVC {
    
    func showDoubleActionPopup(){
        let popup = DoubleActionPopupView()
        popup.appear(sender: self)
        popup.delegate = self
        popup.setupView(type: .deleteWork)
    }

    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title, type: .normal)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .isWorChanged, object: nil)
            pop()
        }
    }
    
    func goToAddNewWork(){
        guard let work = viewModel.workDetails else { return }
        let vc = AddNewWorkVC(viewModel: AddNewWorkVM(mode: .updateItem, workId: viewModel.workId, existingWork: work))
        push(vc)
    }
    
    func goToImageViewer(){
        let image = viewModel.workDetails?.image ?? ""
        let vc = ImageViewerVC(viewModel: ImageViewerVM(image: .remote(image)))
        vc.appear(sender: self)
    }
}

//MARK: - Delegation -

extension WorkDetailsVC : DoubleActionPopupProtocol{
    func didTapFirstAction() {
        viewModel.deleteWorkRequest()
    }
}
