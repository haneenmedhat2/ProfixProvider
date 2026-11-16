//
//  AppTextView.swift
//  Msuom
//
//  Created by MGAbouarab on 02/11/2022.
//

import UIKit

class AppTextView: TextFieldView {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak private var placeholderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties -

    
    @IBInspectable var placeholderLocalizedKey: String? {
        didSet {
            self.placeholderLabel.xibLocKey = placeholderLocalizedKey
        }
    }
        
    //MARK: - Initializer -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    
    private func xibSetUp() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AppTextView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupTextField()
        self.setupContainerView()
        self.containerView.layer.cornerRadius = 16
        //self.placeholderLabel.textAlignment = .center
    }
    private func setupContainerView() {
        self.containerView.layer.cornerRadius = containerViewCornerRadius
        self.containerView.clipsToBounds = true
        self.containerView.backgroundColor = .textFieldBackground
//        self.containerView.layer.borderColor = UIColor.textFieldBorder.cgColor
//        self.containerView.layer.borderWidth = 1
        self.setInactiveState()
    }
    private func setupTextField() {
        self.textView.delegate = self
        
    }
    private func setActiveState() {
        UIView.animate(withDuration: 0.2) {
            // self.containerView.addActiveBorder()
            //   self.tintColor = self.activeTintColor
            self.placeholderLabel.isHidden = true
            //self.titleLabel.isHidden = false
        }
    }
    private func setInactiveState() {
        UIView.animate(withDuration: 0.2) {
            // self.containerView.addInactiveBorder()
            //self.tintColor = self.inActiveTintColor
            self.placeholderLabel.isHidden = false
            //self.titleLabel.isHidden = true
        }
    }
    
    func resetTextView(){
        textView.text = ""
    }
    
    //MARK: - Encapsulation -
    func set(text: String?) {
        guard let text, !text.trimWhiteSpace().isEmpty else {
            self.textView.text = nil
            self.setInactiveState()
            return
        }
        self.textView.text = text
        self.setActiveState()
    }
    
    func textValue() -> String? {
        self.textView.textValue
    }
}

extension AppTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.setActiveState()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text, !text.trimWhiteSpace().isEmpty else {
            self.setInactiveState()
            return
        }
        self.setActiveState()
    }
}

private extension UITextView {
    var textValue: String? {
        guard let word = text?.trimWhiteSpace(), !word.isEmpty else {
            return nil
        }
        return word
    }
}

