//
//  TextFieldExtention.swift
// NewBase
//
//  Created by Mohamed Hadwa on 11/04/2024.
//

import UIKit

//MARK:- Localization
extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if Language.isRTL() {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        } else {
            if textAlignment == .natural {
                self.textAlignment = .left
            }
        }
    }
    
    var textValue: String? {
        guard let word = text?.trimWhiteSpace(), !word.isEmpty else {
            return nil
        }
        return word
    }
}
class PlaceholderUITextView: UITextView {
    
    // MARK: - Properties
    public var resignFirstResponderTimeAnimate: TimeInterval = 0.25
    public var becomeFirstResponderTimeAnimate: TimeInterval = 0.25
    
    /// A UILabel that holds the InputTextView's placeholder text
    open var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Write your notes here".localized
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The placeholder text that appears when there is no text
    @IBInspectable open var placeHolder: String? = "Write your notes here".localized {
        didSet {
            if attributedPlaceholder == nil {
                placeholderLabel.text = placeHolder?.localized
            }
        }
    }
    
    /// The placeholderLabel's textColor
    @IBInspectable open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
            
        }
    }
    
    /// The attributed placeholder
    open var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }
    
    /// The text of the UITextView.
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    /// The attributed text of the UITextView.
    open override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    /// The font of the UITextView. When set the placeholderLabel's font is also updated
    open override var font: UIFont! {
        didSet {
          //  placeholderLabel.font = UIFont(name: UIFont.FontNames.family, size: 10)
        }
    }
    
    /// The textAlignment of the InputTextView. When set the placeholderLabel's textAlignment is also updated
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    /// The Text Container Inset.  When update textContainerInset we will update placholer constaints
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updatePlaceholderLabelConstraints()
        }
    }
    
    open var textContainerLineFragmentPadding: CGFloat = 5 {
        didSet {
            textContainer.lineFragmentPadding = textContainerLineFragmentPadding
            updatePlaceholderLabelConstraints()
        }
    }
    
    /// The constraints of the placeholderLabel
    private var placeholderLabelTopConstraint: NSLayoutConstraint!
    private var placeholderLabelBottomConstraint: NSLayoutConstraint!
    private var placeholderLabelLeadingConstraint: NSLayoutConstraint!
    private var placeholderLabelTrailingConstraint: NSLayoutConstraint!
    private var placeholderLabelWidthConstraint: NSLayoutConstraint!
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setup()
    }
    
    private func commonInit() {
        applyBorderStyle()
    }
    
    func applyBorderStyle(borderWidth: CGFloat = 0.5, borderColor: UIColor = UIColor.secondarySystemFill) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    
    open override func becomeFirstResponder() -> Bool {
        if !canBecomeFirstResponder { return false }
        
        UIView.animate(withDuration: becomeFirstResponderTimeAnimate, animations: {
            super.becomeFirstResponder()
        })
        
        return true
    }
    
    // Override resignFirstResponder to set animation duration to zero
    open override func resignFirstResponder() -> Bool {
        if !canResignFirstResponder { return false }
        
        UIView.animate(withDuration: resignFirstResponderTimeAnimate, animations: {
            super.resignFirstResponder()
        })
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}

extension PlaceholderUITextView {
    
    /// Sets up the default properties
    fileprivate func setup() {
        isEditable = true
        isSelectable = true
        isScrollEnabled = true
        scrollsToTop = false
        isDirectionalLockEnabled = true
        //        backgroundColor = .white//.clear
        layoutManager.allowsNonContiguousLayout = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        
        scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                             left: .leastNonzeroMagnitude,
                                             bottom: .leastNonzeroMagnitude,
                                             right: .leastNonzeroMagnitude)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeHolder?.localized
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)
        setPlaceholderLabelConstraints()
//        self.backgroundColor = UIColor.secondarySystemBackground
        self.layer.cornerRadius = 8
    }
    
    /// Set up constraints for placeholderLabel
    private func setPlaceholderLabelConstraints() {
        placeholderLabelTopConstraint = placeholderLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: textContainerInset.top)
        placeholderLabelBottomConstraint = placeholderLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -textContainerInset.bottom)
        placeholderLabelLeadingConstraint = placeholderLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: textContainerInset.left + textContainer.lineFragmentPadding)
        placeholderLabelTrailingConstraint = placeholderLabel.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -(textContainerInset.right + textContainer.lineFragmentPadding))
        
        placeholderLabelWidthConstraint = placeholderLabel.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 1.0,
                        constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2))
        
        placeholderLabelTopConstraint.isActive = true
        placeholderLabelBottomConstraint.isActive = true
        placeholderLabelLeadingConstraint.isActive = true
        placeholderLabelTrailingConstraint.isActive = true
        placeholderLabelWidthConstraint.isActive = true
    }
    
    /// Updates the placeholderLabel constraints constants to match the textContainerInset and textContainer
    private func updatePlaceholderLabelConstraints() {
        placeholderLabelTopConstraint.constant = textContainerInset.top
        placeholderLabelBottomConstraint.constant = -textContainerInset.bottom
        placeholderLabelLeadingConstraint.constant = textContainerInset.left + textContainer.lineFragmentPadding
        placeholderLabelTrailingConstraint.constant = -(textContainerInset.right + textContainer.lineFragmentPadding)
        placeholderLabelWidthConstraint.constant = -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2)
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}

class RoundTxtF: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    
    
    override func awakeFromNib() {
        //        setupView()
    }
    
    //    func setupView() {
    //        self.layer.cornerRadius = 4
    //        self.layer.borderColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    //        self.layer.borderWidth = 1
    //    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    
    
}










