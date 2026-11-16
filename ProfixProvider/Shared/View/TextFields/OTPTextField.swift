//
//  OTPTextField.swift
//  Waraqa
//
//  Created by Haneen on 06/08/2025.
//

import Foundation
import UIKit
class OTPTextField: UITextField, UITextFieldDelegate {

    var didEnterLastDigit: ((String) -> Void)?
    var defaultText = ""
    
    private var isConfigure = false
    private var digitalLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        return tap
    }()
    
    func configure(with slotsCount: Int = 4) {
        guard !isConfigure else { return }
        isConfigure.toggle()
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotsCount)
        addSubview(labelsStackView)
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStackView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .asciiCapableNumberPad
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }

    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = . fillEqually
        stackView.spacing = 16
        stackView.semanticContentAttribute = .forceLeftToRight
        
        for _ in 0..<count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.text = defaultText
            label.textColor = .black
            label.backgroundColor = .textFieldBackground
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.main.cgColor
            label.clipsToBounds = true
            
            stackView.addArrangedSubview(label)
            
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: 57),
                label.heightAnchor.constraint(equalToConstant: 52)
            ])
            
            digitalLabels.append(label)
        }
        return stackView
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        for label in digitalLabels {
            label.layer.cornerRadius = 12
        }
    }
    
    @objc private func textDidChange() {
        guard let text = self.text, text.count <= digitalLabels.count else { return }
        for i in 0..<digitalLabels.count {
            let currentLabel = digitalLabels[i]
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = defaultText
            }
        }
        if text.count == digitalLabels.count {
            didEnterLastDigit?(text)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitalLabels.count || string.isEmpty
    }
}
