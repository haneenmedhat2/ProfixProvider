//
//  VerificationView.swift
//  Profix
//
//  Created by Haneen on 23/12/2025.
//

import UIKit

class VerificationView: UIView {

    // MARK: - Outlets -
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var OTPField: OTPTextField!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!

    // MARK: - Properties -
    
    weak var delegate: VerificationViewDelegate?

    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed("VerificationView", owner: self)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)

        OTPField.configure(with: 4)
    }

    // MARK: - Public Methods (used by VC) -
    func updateTimer(time: Int) {
        timerLabel.text = String(format: "%02d:%02d", time / 60, time % 60)
    }

    func setResendEnabled(_ enabled: Bool) {
        resendCodeBtn.isEnabled = enabled
        resendCodeBtn.setTitleColor(enabled ? .main : .lightGray, for: .normal)
    }

    // MARK: - Actions -
    @IBAction func didTapConfirm(_ sender: UIButton) {
        delegate?.didTapConfirm(otp: OTPField.text ?? "")
    }

    @IBAction func didTapResend(_ sender: UIButton) {
        delegate?.didTapResend()
    }
}

protocol VerificationViewDelegate: AnyObject {
    func didTapConfirm(otp: String)
    func didTapResend()
}
