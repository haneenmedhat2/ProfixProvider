//
//  DropDownTextView.swift
//  CleafProvider
//
//  Created by Haneen on 14/07/2025.
//

import UIKit

class DropDownTextView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewStackView: UIStackView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var optionalBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var optionalIcon: UIImageView!
    
    //MARK: - Properties -
    
    var onTap : (() -> ())?
    var isRequired  = true
    
    @IBInspectable var isRequiredProperty : Bool = true {
        didSet {
            isRequired = isRequiredProperty
            if isRequired {
                requiredLabel.textColor = .red
            } else{
                requiredLabel.textColor = .darkGray
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
    
    @IBInspectable var placeholder : String = "" {
        didSet {
            placeholderLabel.text = placeholder.localized
        }
    }
    
    @IBInspectable var isButtonHidden : Bool = true {
        didSet {
            optionalBtn.isHidden = isButtonHidden
        }
    }
    
    @IBInspectable var isIconidden : Bool = true {
        didSet{
            optionalIcon.isHidden = isIconidden
        }
    }
    
    @IBInspectable var icon : UIImage? {
        didSet {
            optionalIcon.image = icon
        }
    }
    
    @IBInspectable var isLabelHidden : Bool = false{
        didSet {
            requiredLabel.isHidden = isLabelHidden
        }
    }
    
    @IBInspectable var viewBackgroundColor : UIColor? {
        didSet {
            containerView.backgroundColor = viewBackgroundColor
        }
    }
    
    @IBInspectable var stackBackgroundColor : UIColor = .white  {
        didSet {
            textViewStackView.backgroundColor = stackBackgroundColor
        }
    }
    
    @IBInspectable var keyboardTypeRawValue: Int = 0 {
        didSet {
            if let type = UIKeyboardType(rawValue: keyboardTypeRawValue) {
                textView.keyboardType = type
            }
        }
    }
    
    //MARK: - Initializer -
    
    override init(frame:CGRect){
        super.init(frame: frame)
        configureView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        setupView()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "DropDownTextView")
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //MARK: - View Setup  -
    
    func setupView() {
          textView.delegate = self
          textView.text = ""
          textViewStackView.layer.borderColor = UIColor.textFieldBorder.cgColor
        textViewStackView.layer.borderWidth = 0.5
      //  let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTapField))
       // textViewStackView.addGestureRecognizer(tapGesture)
    }
    
    func setText(_ text: String) {
        textView.text = text
        placeholderLabel.isHidden = !text.trimWhiteSpace().isEmpty
    }
    
    @objc func didTapField(){
        onTap?()
    }
}


extension DropDownTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholderLabel.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text, !text.trimWhiteSpace().isEmpty else {
            self.placeholderLabel.isHidden = false
            return
        }
        self.placeholderLabel.isHidden = true
    }
}


extension DropDownTextView {
    var actualText: String {
        let raw = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if raw.isEmpty { return "" }
        if let ph = placeholderLabel.text, ph == raw { return "" }
        return raw
    }

    var isEmpty: Bool {
        return actualText.isEmpty
    }
}
