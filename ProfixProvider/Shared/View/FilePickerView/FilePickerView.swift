//
//  FilePickerView.swift
//  ProfixProvider
//

import UIKit

@IBDesignable
class FilePickerView: UIView {

    //MARK: - Public API -

    private(set) var fileData: Data?
    private(set) var fileName: String?
    /// URL of an already-uploaded (remote) file, when displaying an existing selection.
    private(set) var fileURLString: String?

    var onFileSelected: ((Data, String) -> Void)?
    var onFileRemoved: (() -> Void)?

    //MARK: - Inspectables -

    @IBInspectable var titleTxt: String = "" {
        didSet { titleLabel.text = titleTxt.localized }
    }

    @IBInspectable var requiredTxt: String = "" {
        didSet { requiredLabel.text = requiredTxt.localized }
    }

    @IBInspectable var placeHolderTxt: String = "" {
        didSet { if fileName == nil { placeholderLabel.text = placeHolderTxt.localized } }
    }

    @IBInspectable var isRequiredProperty: Bool = true {
        didSet { requiredLabel.textColor = isRequiredProperty ? .systemRed : UIColor.border }
    }

    @IBInspectable var isLabelHidden: Bool = false {
        didSet { requiredLabel.isHidden = isLabelHidden }
    }

    @IBInspectable var icon: UIImage? {
        didSet {
            leadingIcon.image = icon
            leadingIcon.isHidden = (icon == nil)
        }
    }

    /// When `false` the field becomes read-only: no picking, no removing — only viewing the selected file.
    @IBInspectable var isEditable: Bool = true {
        didSet { applyEditableState() }
    }

    //MARK: - Subviews -

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()

    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemRed
        label.text = "*"
        return label
    }()

    private let leadingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .placeholderText
        return label
    }()

    private let uploadIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.doc.fill")
        imageView.tintColor = .hint
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var fieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.textFieldBackground.cgColor
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private let fileIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.richtext.fill")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .hint
        button.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        return button
    }()

    private lazy var fileCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.border.withAlphaComponent(0.15)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()

    private var documentPicker: DocumentPicker?

    //MARK: - Initializer -

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    //MARK: - Setup -

    private func setupView() {
        let titleRow = UIStackView(arrangedSubviews: [titleLabel, requiredLabel])
        titleRow.axis = .horizontal
        titleRow.spacing = 4
        titleRow.alignment = .firstBaseline

        let titleSpacer = UIView()
        titleSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleRow.addArrangedSubview(titleSpacer)

        // Upload field
        let fieldStack = UIStackView(arrangedSubviews: [leadingIcon, placeholderLabel, uploadIcon])
        fieldStack.axis = .horizontal
        fieldStack.spacing = 8
        fieldStack.alignment = .center
        fieldStack.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.addSubview(fieldStack)

        // Selected file card
        let cardStack = UIStackView(arrangedSubviews: [fileIcon, fileNameLabel, removeButton])
        cardStack.axis = .horizontal
        cardStack.spacing = 8
        cardStack.alignment = .center
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        fileCard.addSubview(cardStack)

        let rootStack = UIStackView(arrangedSubviews: [titleRow, fieldContainer, fileCard])
        rootStack.axis = .vertical
        rootStack.spacing = 8
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootStack)

        leadingIcon.translatesAutoresizingMaskIntoConstraints = false
        uploadIcon.translatesAutoresizingMaskIntoConstraints = false
        fileIcon.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        placeholderLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        fileNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fileNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: topAnchor),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            fieldContainer.heightAnchor.constraint(equalToConstant: 48),
            fieldStack.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 12),
            fieldStack.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -12),
            fieldStack.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),

            leadingIcon.widthAnchor.constraint(equalToConstant: 24),
            leadingIcon.heightAnchor.constraint(equalToConstant: 24),
            uploadIcon.widthAnchor.constraint(equalToConstant: 22),
            uploadIcon.heightAnchor.constraint(equalToConstant: 22),

            fileCard.heightAnchor.constraint(equalToConstant: 44),
            cardStack.leadingAnchor.constraint(equalTo: fileCard.leadingAnchor, constant: 12),
            cardStack.trailingAnchor.constraint(equalTo: fileCard.trailingAnchor, constant: -12),
            cardStack.centerYAnchor.constraint(equalTo: fileCard.centerYAnchor),

            fileIcon.widthAnchor.constraint(equalToConstant: 20),
            fileIcon.heightAnchor.constraint(equalToConstant: 20),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24),
        ])

        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)

        let fieldTap = UITapGestureRecognizer(target: self, action: #selector(didTapField))
        fieldContainer.addGestureRecognizer(fieldTap)
        fieldContainer.isUserInteractionEnabled = true

        let cardTap = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        fileCard.addGestureRecognizer(cardTap)
        fileCard.isUserInteractionEnabled = true
    }

    private func applyEditableState() {
        uploadIcon.isHidden = !isEditable
        removeButton.isHidden = !isEditable
        // In read-only mode the upload field is hidden — only the selected-file card is shown.
        fieldContainer.isHidden = !isEditable
    }

    //MARK: - Actions -

    @objc private func didTapField() {
        if isEditable {
            presentPicker()
        } else {
            openCurrentFile()
        }
    }

    @objc private func didTapCard() {
        openCurrentFile()
    }

    @objc private func didTapRemove() {
        clear()
    }

    //MARK: - File Handling -

    private func presentPicker() {
        let picker = DocumentPicker()
        self.documentPicker = picker
        picker.pickFile { [weak self] name, data in
            guard let self = self else { return }
            self.setFile(data: data, name: name)
            self.onFileSelected?(data, name)
        }
    }

    /// Set a locally-picked file (carries raw data to be uploaded).
    func setFile(data: Data, name: String) {
        fileData = data
        fileName = name
        fileURLString = nil
        fileNameLabel.text = name
        fileCard.isHidden = false
    }

    /// Display an already-uploaded remote file (e.g. from a profile response). Tapping it opens the URL.
    func setRemoteFile(urlString: String?) {
        guard let urlString = urlString?.trimWhiteSpace(), !urlString.isEmpty else { return }
        fileURLString = urlString
        fileData = nil
        fileName = (urlString as NSString).lastPathComponent
        fileNameLabel.text = fileName
        fileCard.isHidden = false
    }

    func clear() {
        fileData = nil
        fileName = nil
        fileURLString = nil
        fileNameLabel.text = nil
        fileCard.isHidden = true
        placeholderLabel.text = placeHolderTxt.localized
        onFileRemoved?()
    }

    private func openCurrentFile() {
        guard let urlString = fileURLString,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
