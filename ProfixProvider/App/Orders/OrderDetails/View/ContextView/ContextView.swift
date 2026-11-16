//
//  ContextView.swift
//  Profix
//
//  Created by Haneen on 18/01/2026.
//

import UIKit
import Cosmos

class ContextView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var contextTextView: UITextView!
    
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
        let nib = UINib(nibName: "ContextView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setupData(context : String? , cosmosValue : String?, type: ContextViewType){
        if let context = context , !context.trimWhiteSpace().isEmpty {
            contextTextView.text = context
        } else {
            contextTextView.text = "There is no comment".localized
        }
        
        cosmosView.rating = cosmosValue?.toDouble() ?? 0.0
        cosmosView.settings.fillMode = .precise
        cosmosView.isHidden = type.isRatingHidden
        
        titleLabel.text = type.title
    }
}
