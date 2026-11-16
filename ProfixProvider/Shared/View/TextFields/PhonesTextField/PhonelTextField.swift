//
//  GeneralTextField.swift
//  Cleaf
//
//  Created by Haneen Medhat on 26/04/2025.
//

import UIKit
@IBDesignable
class PhoneTextField: UIView {
    
 //MARK: - Outlets -
    
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var phonesBtn: UIButton!
    @IBOutlet weak var trailingIconImg: UIImageView!
    @IBOutlet weak var countryIcon: UIImageView!
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var txtFieldStackView: UIStackView!
    
//MARK: - Properties -
    
    var onTap : (() -> ())?
    var isRequired  = true
    var iRequiredLabelHidden = false
    
    @IBInspectable var isRequiredProperty: Bool = true {
        didSet {
            isRequired = isRequiredProperty
           // updateUIIfNeeded()
        }
    }

    @IBInspectable var isLabelHidden: Bool = false {
        didSet {
            iRequiredLabelHidden = isLabelHidden
           // updateUIIfNeeded()
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

    @IBInspectable var stackBackgroundColor : UIColor? {
        didSet{
            txtFieldStackView.backgroundColor = stackBackgroundColor
        }
    }
    
    @IBInspectable var stackBorderColor : UIColor? {
        didSet{
            txtFieldStackView.layer.borderColor = stackBorderColor?.cgColor
            txtFieldStackView.layer.borderWidth = 0.5
            txtFieldStackView.layer.masksToBounds = true
        }
    }
    
    //MARK: - Initializer -
    
    override init(frame:CGRect){
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUIIfNeeded()
    }

    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "PhoneTextField")
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        setupView()
    }

    func setupView(){
        txtField.keyboardType = .asciiCapableNumberPad
        txtFieldStackView.layer.cornerRadius = 12
        updateUIIfNeeded()
    }
    
    private func updateUIIfNeeded() {
        guard requiredLabel != nil else { return }

        requiredLabel.textColor = isRequired ? .systemRed : UIColor.border
        requiredLabel.isHidden = iRequiredLabelHidden
    }

    
//MARK: - Actions -
    
    @IBAction func showPhoneView(_ sender: UIButton) {
        onTap?()
    }
}
