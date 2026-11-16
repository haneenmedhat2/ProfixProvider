//
//  PledgePopup.swift
//  Profix
//
//  Created by Haneen on 25/06/2026.
//

import UIKit

class PledgePopup: BaseViewController {

    //MARK: - Properties -

    var delegate: PledgePopupProtocol?

    private var content: String = ""

    //MARK: - UI -

    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.6)
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "pledge_title".localized
        label.font = .myBoldFont(ofSize: 18)
        label.textColor = .mainDarkFont
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .close).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        return textView
    }()

    private lazy var checkbox: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor.main.cgColor
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
        return button
    }()

    private let agreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "pledge_agree".localized
        label.font = .myRegularFont(ofSize: 14)
        label.textColor = .mainDarkFont
        label.numberOfLines = 0
        return label
    }()

    private lazy var confirmButton: MainButton = {
        let button = MainButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("confirm".localized, for: .normal)
        button.titleLabel?.font = .myMediumFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return button
    }()

    private var isChecked = false {
        didSet { updateCheckState() }
    }

    private var isSubmitting = false

    private var textHeightConstraint: NSLayoutConstraint!

    //MARK: - Initializer -

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        layoutUI()
        updateCheckState()
    }

    //MARK: - Configuration -

    private func configView() {
        view.backgroundColor = .clear
        backView.alpha = 0
        contentView.alpha = 0
        closeButton.isHidden = true
    }

    private func layoutUI() {
        view.addSubview(backView)
        view.addSubview(contentView)

        let checkRow = UIStackView(arrangedSubviews: [checkbox, agreeLabel])
        checkRow.translatesAutoresizingMaskIntoConstraints = false
        checkRow.axis = .horizontal
        checkRow.spacing = 8
        checkRow.alignment = .center

        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(contentTextView)
        contentView.addSubview(checkRow)
        contentView.addSubview(confirmButton)

        textHeightConstraint = contentTextView.heightAnchor.constraint(equalToConstant: 200)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            contentView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),

            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),

            contentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textHeightConstraint,

            checkRow.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 16),
            checkRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkbox.widthAnchor.constraint(equalToConstant: 22),
            checkbox.heightAnchor.constraint(equalToConstant: 22),

            confirmButton.topAnchor.constraint(equalTo: checkRow.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    //MARK: - Public -

    func setupView(content: String) {
        self.content = content
        loadViewIfNeeded()
        contentTextView.attributedText = content.htmlToAttributedString
        adjustTextHeight()
    }

    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }

    func dismissAfterAcceptance() {
        hide()
    }

    func setSubmitting(_ isSubmitting: Bool) {
        self.isSubmitting = isSubmitting
        confirmButton.isEnabled = isChecked && !isSubmitting
    }

    //MARK: - Animation -

    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    private func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false) {
                completion?()
            }
        }
    }

    //MARK: - Helpers -

    private func adjustTextHeight() {
        let availableWidth = UIScreen.main.bounds.width - 48 - 32
        let fitting = contentTextView.sizeThatFits(CGSize(width: availableWidth, height: .greatestFiniteMagnitude))
        textHeightConstraint.constant = min(max(fitting.height, 60), 320)
    }

    private func updateCheckState() {
        checkbox.backgroundColor = isChecked ? .main : .clear
        checkbox.setImage(isChecked ? UIImage(systemName: "checkmark") : nil, for: .normal)
        confirmButton.isEnabled = isChecked
        confirmButton.alpha = isChecked ? 1 : 0.5
    }

    //MARK: - Actions -

    @objc private func didTapCheckbox() {
        isChecked.toggle()
    }

    @objc private func didTapClose() {
        hide()
    }

    @objc private func didTapConfirm() {
        guard isChecked, !isSubmitting else { return }
        setSubmitting(true)
        delegate?.didAgreeToPledge()
    }
}

//MARK: - PledgePopup Protocol -

protocol PledgePopupProtocol: AnyObject {
    func didAgreeToPledge()
}
