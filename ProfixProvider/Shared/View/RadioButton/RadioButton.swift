//
//  RadioButton.swift
//  Cleaf
//
//  Created by Haneen on 19/05/2025.
//

import Foundation
import UIKit

class RadioButton: UIControl {
    
    //MARK: - Properites -
    
    var delegate : RadioButtonDelegate?
    
    var isOn: Bool = false {
         didSet {
             updateState()
             delegate?.didTapOn()
         }
     }
     
     private let checkedView: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
     
     // MARK: - Initializers -
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         setup()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setup()
     }
     
     // MARK: - Setup -
     
     private func setup() {
         addSubview(checkedView)
         backgroundColor = .white
         layer.borderWidth = 1.2
         
         NSLayoutConstraint.activate([
             checkedView.centerXAnchor.constraint(equalTo: centerXAnchor),
             checkedView.centerYAnchor.constraint(equalTo: centerYAnchor),
             checkedView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
             checkedView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
         ])
         
         updateState()
     }
     
     // MARK: - Layout -
     
     override func layoutSubviews() {
         super.layoutSubviews()
         layer.cornerRadius = bounds.height / 2
         checkedView.layer.cornerRadius = (bounds.height / 2) * 0.5
     }
     
     // MARK: - Touch Handling -
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesBegan(touches, with: event)
         sendActions(for: .valueChanged)
     }
     
     override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
         return bounds.inset(by: UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)).contains(point)
     }
     
     // MARK: - State Update -
     
     private func updateState() {
         if isOn {
             backgroundColor = .white
             layer.borderColor = UIColor.main.cgColor
             checkedView.backgroundColor = .main
             checkedView.isHidden = false
         } else {
             backgroundColor = .white
             layer.borderColor = UIColor.hint.cgColor
             checkedView.isHidden = true
         }
     }
 }

//MARK: - Delegate Protocol -

protocol RadioButtonDelegate {
    func didTapOn()
}
