//
//  PasswordTextField.swift
//  Esterad
//
//  Created by Haneen on 19/10/2025.
//

import UIKit

class PasswordTextField: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtFieldStackView: UIStackView!
    @IBOutlet weak var optionalBtn: UIButton!
    
    //MARK: - Properties -
    
    var onOptionalBtnTapped : (() -> Void)?
    var isRequired  = true
    var isPasswordVisible = false
    
    @IBInspectable var isRequiredProperty : Bool = true {
        didSet{
            isRequired = isRequiredProperty
            if isRequired {
                requiredLabel.textColor = .systemRed
            } else {
                requiredLabel.textColor = UIColor.border
            }
        }
    }
    
    @IBInspectable var titleTxt : String = "" {
        didSet {
            titleLabel.text = titleTxt.localized
        }
    }
    
    @IBInspectable var requiredTxt : String = "" {
        didSet {
            requiredLabel.text = requiredTxt.localized
        }
    }
    
    @IBInspectable var placeHolderTxt : String = "" {
        didSet{
            txtField.placeholder = placeHolderTxt.localized
        }
    }
    
    @IBInspectable var isLabelHidden : Bool = false {
        didSet{
            requiredLabel.isHidden = isLabelHidden
        }
    }
    
    @IBInspectable var isButtonHidden : Bool = true {
        didSet{
            optionalBtn.isHidden = isButtonHidden
        }
    }
    
    @IBInspectable var buttonIcon : UIImage? {
        didSet{
            optionalBtn.setImage(buttonIcon, for: .normal)
        }
    }
        
    @IBInspectable var stackBackgroundColor : UIColor? {
        didSet{
            txtFieldStackView.backgroundColor = stackBackgroundColor
        }
    }
    
    @IBInspectable var stackBorderColor : UIColor? {
        didSet{
            txtFieldStackView.layer.borderColor = stackBorderColor?.cgColor
            txtFieldStackView.layer.borderWidth = 1
            txtFieldStackView.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var keyboardTypeRawValue: Int = 0 {
        didSet {
            if let type = UIKeyboardType(rawValue: keyboardTypeRawValue) {
                txtField.keyboardType = type
            }
        }
    }
    
    //MARK: - Initializer -
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "PasswordTextField")
        view.frame = self.bounds
        self.addSubview(view)
        txtField.isSecureTextEntry = true
    }
    
    private func togglePasswordVisibility(){
        isPasswordVisible.toggle()
        txtField.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye.fill" : "eye.slash.fill"
        optionalBtn.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapOptionalBtn(_ sender: UIButton) {
        togglePasswordVisibility()
    }
}
