//
//  DoubleActionPopupView.swift
//  Waraqa
//
//  Created by Haneen on 26/08/2025.
//

import UIKit

class DoubleActionPopupView: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstBtn: MainButton!
    @IBOutlet weak var secBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secTitleLabel: UILabel!
    
    //MARK: - Properites -
    
    var delegate : DoubleActionPopupProtocol?
    
    //MARK: - Initializer  -
    
    init() {
        super.init(nibName: "DoubleActionPopupView", bundle: nil)
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
    
    func hide(didCallDelegate : Bool){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false){
                if didCallDelegate {
                    self.delegate?.didTapFirstAction()
                }
            }
            self.removeFromParent()
        }
    }
    
    //MARK: - Setup Popup -
       
    func setupView(type: DoubleActionPopupType) {
        titleLabel.text = type.mainTitle
        secTitleLabel.text = type.secTitle
        
        firstBtn.setTitle(type.firstBtnTitle, for: .normal)
        secBtn.setTitle(type.secBtnTitle, for: .normal)
        
        imageView.image = UIImage(named: type.imageName)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapFirstBtn(_ sender: UIButton) {
        hide(didCallDelegate: true)
    }
    
    
    @IBAction func didTapSecBtn(_ sender: UIButton) {
        hide(didCallDelegate: false)
    }
}

//MARK: - DoubleActionPopupView Protocol -

protocol DoubleActionPopupProtocol : AnyObject {
   func didTapFirstAction()
}

 
