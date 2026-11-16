//
//  IconTextGeneralButton.swift
//  Cleaf
//
//  Created by Haneen on 05/07/2025.
//

import UIKit

class IconTextGeneralButton: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    //MARK: - Properties -
    
    var onTap: (() -> Void)?

    @IBInspectable var iconImageName: UIImage? {
        didSet {
            iconImage.image =  iconImageName
        }
    }
    
    @IBInspectable var buttonLabelText: String? {
        didSet {
            buttonLabel.text = buttonLabelText?.localized
        }
    }
    
    @IBInspectable var btnBackgroundColor : UIColor? {
        didSet {
            contentView.backgroundColor = btnBackgroundColor
        }
    }
    
    @IBInspectable var btnBorderColor : UIColor? {
        didSet {
            contentView.layer.borderColor = btnBorderColor?.cgColor
            contentView.layer.borderWidth = 1
            contentView.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var fontColor : UIColor? {
        didSet {
            buttonLabel.textColor = fontColor
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
    
    func loadViewFromNib(nibName:String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
     
    func configureView() {
        let view = loadViewFromNib(nibName: "IconTextGeneralButton")
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setupView() {
           contentView.layer.cornerRadius = 16
           contentView.layer.masksToBounds = true
           
           self.isUserInteractionEnabled = true
           
           let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
           self.addGestureRecognizer(tap)
       }
       
       //MARK: - Tap Handling -
       @objc private func handleTap() {
           onTap?()   
       }
}
