//
//  PickerFieldView.swift
//  Esterad
//
//  Created by Haneen on 17/11/2025.
//

import UIKit

class PickerFieldView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtFieldStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var leadingIcon: UIImageView!

    //MARK: - Properties -
        
    var isRequired  = true

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
        didSet{
            titleLabel.text = titleTxt.localized
        }
    }
    
    @IBInspectable var requiredTxt : String = "" {
        didSet {
            requiredLabel.text = requiredTxt.localized
        }
    }
    
    @IBInspectable var isLabelHidden : Bool = false {
        didSet{
            requiredLabel.isHidden = isLabelHidden
        }
    }
    
    @IBInspectable var placeHolderTxt : String = "" {
        didSet{
            txtField.placeholder = placeHolderTxt.localized
        }
    }
        
    @IBInspectable var viewBackgroundColor : UIColor? {
        didSet{
            containerView.backgroundColor = viewBackgroundColor
        }
    }
    
    @IBInspectable var stackBackgroundColor : UIColor? {
        didSet{
          txtFieldStackView.backgroundColor = stackBackgroundColor
        //    containerStack.backgroundColor = stackBackgroundColor
        }
    }
    
    @IBInspectable var stackBorderColor : UIColor? {
        didSet{
            containerStack.layer.borderColor = stackBorderColor?.cgColor
            containerStack.layer.borderWidth = 1
            containerStack.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var icon : UIImage? {
        didSet{
            leadingIcon.image = icon
        }
    }
    
    var delegate: PickerFieldViewDelegate?

    //MARK: - Initializer -
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        setupTapGesture()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "PickerFieldView")
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func setupTapGesture() {
           let tap = UITapGestureRecognizer(target: self, action: #selector(didTapField))
           containerStack.addGestureRecognizer(tap)
           txtField.isUserInteractionEnabled = false
       }

       @objc private func didTapField() {
           delegate?.pickerFieldViewDidTap(self)
       }
}

protocol PickerFieldViewDelegate: AnyObject {
    func pickerFieldViewDidTap(_ view: PickerFieldView)
}
