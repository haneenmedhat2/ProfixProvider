//
//  SecurityCodePopup.swift
//  ProfixProvider
//
//  Created by Haneen on 10/02/2026.
//

import UIKit

class SecurityCodePopup: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var securityCodeTextField: GeneralTextField!
    
    //MARK: - Properites -
    
    var delegate : SecurityCodePopupProtocol?
    var securityCode : String = ""
    
    //MARK: - Initializer  -
    
    init() {
        super.init(nibName: "SecurityCodePopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    //MARK: - View Configuration -
    
    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor  = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        contentView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackView))
        backView.addGestureRecognizer(tap)
    }
    
    func appear(sender:UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide(isDelegateCalled : Bool){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false){
                if isDelegateCalled {
                    self.delegate?.didTapConfirm(code: self.securityCode)
                }
            }
            self.removeFromParent()
        }
    }
    
    
    //MARK: - Action -
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        validateSecurityCode()
        
    }
    
    @objc func didTapBackView(){
        hide(isDelegateCalled: false)
    }
}

//MARK: - Validation -
extension SecurityCodePopup {
    func validateSecurityCode() {
        do {
            securityCode = try ValidationService.validate(securityCode: securityCodeTextField.txtField.text)
            hide(isDelegateCalled: true)
            
        } catch(let error) {
            show(errorMessage: error.localizedDescription)
        }
    }
}

//MARK: - PaymentAlertPopup Protocol -

protocol SecurityCodePopupProtocol : AnyObject {
    func didTapConfirm(code : String)
}
