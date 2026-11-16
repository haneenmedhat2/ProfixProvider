//
//  ClientDetailsView.swift
//  ProfixProvider
//
//  Created by Haneen on 09/02/2026.
//

import UIKit
import Kingfisher

class ClientDetailsView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var clientImage: UIImageView!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientPhoneStackView: UIStackView!
    @IBOutlet weak var clientPhone: UITextView!
    @IBOutlet weak var clientAddressLabel: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: - Properites -
     

    //MARK: - Initializer -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
    }
    
    //MARK: - Nib file configuration -
    
    func viewSetup(){
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
        
    func loadViewFromNib()-> UIView {
        let nib = UINib(nibName: "ClientDetailsView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setupData(model : OrderDetailsModel){
        clientImage.kf.setImage(with: URL(string: model.userAvatar ?? "" ))
        clientNameLabel.text = model.userName
        clientPhoneStackView.isHidden = model.isClientPhoneHidden
        clientPhone.text = model.userPhone
        clientAddressLabel.text = model.address
        orderId.text =  "order_num".localized + "#" + "\(model.id ?? 0)"
        createdAt.text =  model.createdAt ?? ""
        timeLabel.text = model.time ?? ""
    }
}
