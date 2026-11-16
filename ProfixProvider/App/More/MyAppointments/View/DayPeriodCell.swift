import UIKit

final class DayPeriodCell: UITableViewCell {
    private let periodLabel = UILabel()
    private let stateLabel = UILabel()
    private let closedSwitch = UISwitch()
    var onToggle: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        periodLabel.font = .myMediumFont(ofSize: 16)
        periodLabel.numberOfLines = 0
        periodLabel.textAlignment = .natural
        stateLabel.font = .myRegularFont(ofSize: 13)
        stateLabel.textColor = .secondaryLabel
        stateLabel.numberOfLines = 0
        let labels = UIStackView(arrangedSubviews: [periodLabel, stateLabel])
        labels.axis = .vertical
        labels.spacing = 6
        let row = UIStackView(arrangedSubviews: [labels, closedSwitch])
        row.alignment = .center
        row.spacing = 16
        row.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(row)
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            row.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        closedSwitch.onTintColor = .main
        closedSwitch.addTarget(self, action: #selector(didToggle), for: .valueChanged)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(period: DayPeriod, enabled: Bool) {
        periodLabel.text = period.label
        closedSwitch.isOn = period.isClosed
        closedSwitch.isEnabled = enabled
        closedSwitch.accessibilityLabel = period.label + ", " + "period_closed".localized
        stateLabel.text = (period.isClosed ? "period_unavailable" : "period_available").localized
    }

    @objc private func didToggle() {
        onToggle?(closedSwitch.isOn)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onToggle = nil
    }
}
