//
//  StaticPagesView.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import UIKit

class StaticPagesView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var textView: UITextView!
    
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
        let view = loadViewFromNib(nibName: "StaticPagesView")
        view.frame = self.bounds
        self.addSubview(view)
    }
   
    func setupView(content : String){
        let convertedString = content.htmlToAttributedString
        textView.attributedText = convertedString
    }
}
