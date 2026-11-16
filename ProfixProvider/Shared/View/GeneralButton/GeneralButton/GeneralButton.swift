//
//  MainButton.swift
//  Cleaf
//
//  Created by Haneen Medhat on 26/04/2025.
//

import UIKit

class MainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInitialDesign()
        self.addPulsateAnimationWhenTapped()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupInitialDesign()
        self.addPulsateAnimationWhenTapped()
    }
    
    fileprivate func setupInitialDesign() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = UIColor.main
        //self.titleLabel?.font = self.titleLabel?.font.withSize(16)
        self.setTitleColor(.white, for: .normal)
        if self.constraints.first(where: { $0.firstAttribute == .height }) == nil {
            self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
    }
    
    private func addPulsateAnimationWhenTapped() {
        self.addTarget(self, action: #selector(self.flash), for: .touchUpInside)
    }
    
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}


class RedButton: MainButton {
    override func setupInitialDesign() {
        super.setupInitialDesign()
        self.backgroundColor = .systemRed
    }
}

class GrayButton: MainButton {
    override func setupInitialDesign() {
        super.setupInitialDesign()
        self.backgroundColor = .systemGray4
        self.setTitleColor(.label, for: .normal)
    }
}
class CircleButton: MainButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
    }
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}

class CornerButton: UIButton {
    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}


class UnderlineButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        updateTitle()
    }

    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        updateTitle()
    }

    private func setup() {
        updateTitle()
    }

    private func updateTitle() {
        guard let title = self.title(for: .normal),
              let titleColor = self.titleColor(for: .normal) else { return }

        let attributedString = NSAttributedString(
            string: title.localized,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: titleColor
            ]
        )

        self.setAttributedTitle(attributedString, for: .normal)
    }
}



// MARK: - Badge Button -

class SSBadgeCountButton: UIButton {

    // MARK: - Properties -
    private let badgeLabel = UILabel()

    var badge: String? {
        didSet {
            updateBadge()
        }
    }

    public var badgeBackgroundColor: UIColor = .red {
        didSet { badgeLabel.backgroundColor = badgeBackgroundColor }
    }

    public var badgeTextColor: UIColor = .white {
        didSet { badgeLabel.textColor = badgeTextColor }
    }

    public var badgeFont: UIFont = .systemFont(ofSize: 12.0) {
        didSet { badgeLabel.font = badgeFont }
    }

    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet { updateBadge() }
    }

    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBadgeLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureBadgeLabel()
    }

    // MARK: - Setup -
    private func configureBadgeLabel() {
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.textAlignment = .center
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = true
    }

    // MARK: - Update Badge -
    private func updateBadge() {
        // Hide if badge is nil or "0"
        guard let badge = badge, badge != "0" else {
            badgeLabel.isHidden = true
            return
        }

        badgeLabel.isHidden = false
        badgeLabel.text = badge
        badgeLabel.sizeToFit()

        // Ultra-small badge (tiny dot or single-digit bubble)
        let badgeSize = badgeLabel.intrinsicContentSize
        let height = max(8, Double(badgeSize.height))        // smaller height (~8pt)
        let width = max(height, Double(badgeSize.width) + 3) // narrower width

        var x: Double
        var y: Double

        if let insets = badgeEdgeInsets {
            x = Double(bounds.width) - Double(width / 2) - Double(insets.right)
            y = Double(-height / 2) + Double(insets.top)
        } else {
            x = Language.isRTL() ? -width / 2 : Double(bounds.width) - width / 2
            y = -height / 5   // slightly above the icon
        }

        badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height / 2

        // Optional: make text fit inside smaller bubble
        badgeLabel.font = badgeFont.withSize(9)
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        updateBadge()
    }
}

final class NotificationButtonView: UIView {

    private let button = UIButton(type: .system)
    private let badgeLabel = UILabel()

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 38).isActive = true
        heightAnchor.constraint(equalToConstant: 38).isActive = true

        setupButton()
        setupBadge()
    }

    private func setupButton() {
        button.setImage(
            UIImage(resource: .notificationBtn).withRenderingMode(.alwaysOriginal),
            for: .normal
        )

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4

        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupBadge() {
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .red
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.clipsToBounds = true
        badgeLabel.isHidden = true

        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(badgeLabel)

        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -4),
            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            badgeLabel.heightAnchor.constraint(equalToConstant: 18),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])

        badgeLabel.layer.cornerRadius = 9
    }

    @objc private func buttonTapped() {
        onTap?()
    }

    func updateBadge(count: Int) {
        if count > 0 {
            badgeLabel.isHidden = false
            badgeLabel.text = "\(min(count, 99))"
        } else {
            badgeLabel.isHidden = true
        }
    }
}
