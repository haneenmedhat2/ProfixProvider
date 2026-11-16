//
//  LottieView.swift
//  Waraqa
//
//  Created by Haneen on 03/08/2025.
//

import UIKit
import Lottie

final class LottieView: UIView {
    
    private let animationView = LottieAnimationView()
    
    @IBInspectable
    var animationName: String = "" {
        didSet {
            animationView.animation = LottieAnimation.named(animationName)
            animationView.play()
        }
    }
    
    @IBInspectable
    var isInfinityLoop: Bool = true {
        didSet {
            animationView.loopMode = isInfinityLoop ? .loop : .playOnce
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = isInfinityLoop ? .loop : .playOnce
        animationView.backgroundBehavior = .pauseAndRestore
    }
    
    func play() {
        animationView.play()
    }
    
    func stop() {
        animationView.stop()
    }
    
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}
