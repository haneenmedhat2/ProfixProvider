//
//  AvailabilityCell.swift
//  ProfixProvider
//
//  Created by Haneen on 19/04/2026.
//

import UIKit

protocol AvailabilityCellDelegate: AnyObject {
    func availabilityCell(_ cell: AvailabilityCell, didChangeValue isOn: Bool)
}

final class AvailabilityCell: UICollectionViewCell {

    static let reuseIdentifier = "AvailabilityCell"

    weak var delegate: AvailabilityCellDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 14, weight: .medium)
        label.textColor = .main
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let availabilitySwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .main
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "StateColor")
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(availabilitySwitch)

        availabilitySwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            availabilitySwitch.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16),
            availabilitySwitch.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            titleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: availabilitySwitch.rightAnchor, constant: 12)
        ])
    }

    func configure(isOn: Bool) {
        titleLabel.text = isOn ? "available".localized : "not_available".localized
        availabilitySwitch.setOn(isOn, animated: false)
    }

    @objc private func switchChanged(_ sender: UISwitch) {
        titleLabel.text = sender.isOn ? "available".localized : "not_available".localized
        delegate?.availabilityCell(self, didChangeValue: sender.isOn)
    }
}
