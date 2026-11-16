//
//  SkeletonLoadingView.swift
//  ProfixProvider
//
//  Created by Haneen on 14/02/2026.
//


import UIKit

final class SkeletonLoadingView: UIView {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var gradientLayer: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        setupScrollView()
        setupContent()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupContent() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        buildSkeletonContent()
    }
    
    private func buildSkeletonContent() {
        // Banner
        stackView.addArrangedSubview(createBox(height: 160, cornerRadius: 12))
        
        // Stats header
        let statsHeader = createBox(height: 20, cornerRadius: 4)
        statsHeader.widthAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.addArrangedSubview(statsHeader)
        
        // Stats grid
        stackView.addArrangedSubview(createHorizontalRow(count: 2, height: 65))
        stackView.addArrangedSubview(createHorizontalRow(count: 2, height: 65))
        stackView.setCustomSpacing(24, after: stackView.arrangedSubviews.last!)
        
        // Orders header
        let ordersHeader = createBox(height: 20, cornerRadius: 4)
        ordersHeader.widthAnchor.constraint(equalToConstant: 120).isActive = true
        stackView.addArrangedSubview(ordersHeader)
        
        // Order cards
        for _ in 0..<3 {
            stackView.addArrangedSubview(createOrderCard())
        }
    }
    
    private func createBox(height: CGFloat, cornerRadius: CGFloat) -> UIView {
        let box = UIView()
        box.backgroundColor = .systemGray5
        box.layer.cornerRadius = cornerRadius
        box.translatesAutoresizingMaskIntoConstraints = false
        box.heightAnchor.constraint(equalToConstant: height).isActive = true
        return box
    }
    
    private func createHorizontalRow(count: Int, height: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        for _ in 0..<count {
            stack.addArrangedSubview(createBox(height: height, cornerRadius: 8))
        }
        
        return stack
    }
    
    private func createOrderCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
        
        let line1 = createBox(height: 16, cornerRadius: 4)
        line1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let line2 = createBox(height: 14, cornerRadius: 4)
        
        let line3 = createBox(height: 14, cornerRadius: 4)
        line3.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        stack.addArrangedSubview(line1)
        stack.addArrangedSubview(line2)
        stack.addArrangedSubview(line3)
        
        return card
    }
    
    func startShimmering() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.locations = [0, 0.5, 1]
        
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}