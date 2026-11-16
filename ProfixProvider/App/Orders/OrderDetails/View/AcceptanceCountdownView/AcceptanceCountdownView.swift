import UIKit

final class AcceptanceCountdownView: UIView {
    private let messageLabel = UILabel()
    private let clockLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.main.withAlphaComponent(0.08)
        layer.cornerRadius = 12
        messageLabel.numberOfLines = 0
        messageLabel.font = .myRegularFont(ofSize: 14)
        messageLabel.textAlignment = .natural
        clockLabel.font = .monospacedDigitSystemFont(ofSize: 24, weight: .semibold)
        clockLabel.textColor = .main
        clockLabel.textAlignment = .center
        clockLabel.semanticContentAttribute = .forceLeftToRight
        let stack = UIStackView(arrangedSubviews: [messageLabel, clockLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        isHidden = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(message: String?) {
        messageLabel.text = message
        messageLabel.isHidden = message?.isEmpty != false
    }

    func update(seconds: Int) {
        clockLabel.text = AcceptanceCountdown.clock(seconds: seconds)
        isHidden = seconds <= 0
    }
}
