//
//  PreviousWorksVC.swift
//  ProfixProvider
//
//  Created by Haneen on 27/01/2026.
//

import UIKit

class PreviousWorksVC: BaseViewController {

    //MARK: - Outlets -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "previous_works".localized
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapAddService(_ sender: UIButton) {
        goToAddService()
    }
}

//MARK: - Routes -
extension PreviousWorksVC {
    func goToAddService(){
        let vc = AddNewWorkVC(viewModel: AddNewWorkVM(mode: .completeInfo, workId: nil))
        push(vc)
    }
}
