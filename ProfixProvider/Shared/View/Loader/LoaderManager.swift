//
//  LoaderManager.swift
// NewBase
//
//  Created by MGAbouarab on 13/01/2024.
//

import UIKit
import Lottie

class LoaderManager {
    
    //MARK: - Properties -
    private var count: Int = 0 {
        didSet {
            if count == 0 {
                self.removeLoaderView()
            } else if count == 1 {
                self.addLoaderViewToWindow()
            }
        }
    }
    lazy private var loaderView = LoaderView()
    static let shared = LoaderManager()
    
    //MARK: - Initializer -
    private init() {
        self.loaderView.alpha = 0
        self.loaderView.backgroundColor = .black.withAlphaComponent(0)
    }
    
    //MARK: - Design -
    private func addLoaderViewToWindow() {
        guard let window = SceneDelegate.current?.window else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard self.count > 0 else {return}
            window.addSubview(self.loaderView)
            window.bringSubviewToFront(self.loaderView)
            self.loaderView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
            self.loaderView.frame = window.frame
            UIView.animate(withDuration: 0.4) {
                self.loaderView.alpha = 1
                self.loaderView.backgroundColor = .black.withAlphaComponent(0.6)
            }
        }
    }
    private func removeLoaderView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.loaderView.alpha = 0
                self.loaderView.backgroundColor = .black.withAlphaComponent(0)
            } completion: { _ in
                self.loaderView.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Client -
    func show() {
        self.count += 1
    }
    func hide() {
        guard count > 0 else {return}
        self.count -= 1
    }
    
}




class AppIndicator {
    
    //MARK: - properties -
    private let indicatorContainer: UIView  = UIView()
    private let indicatorView: UIView = UIView()
    private let lottieAnimationView: LottieAnimationView = LottieAnimationView()
    private let length: CGFloat = UIScreen.main.bounds.width * 0.75
    private let innerLength: CGFloat = UIScreen.main.bounds.width * 0.75
    private let tag: Int = 19920301
    static let shared: AppIndicator = AppIndicator()
    
    //MARK: - Initializer -
    private init() {}
    
    //MARK: - Private Methods -
    private func handleInitialView(animationName: String) {
        self.indicatorContainer.tag = self.tag
        self.indicatorContainer.alpha = 0
        self.indicatorContainer.backgroundColor = .black.withAlphaComponent(0.8)
        self.indicatorView.backgroundColor = .clear
        
        self.lottieAnimationView.animation = LottieAnimation.named(animationName)
        self.lottieAnimationView.contentMode = .scaleAspectFit
        self.lottieAnimationView.loopMode = .loop
        self.lottieAnimationView.play()

        self.indicatorView.layer.cornerRadius = 8
        self.indicatorView.clipsToBounds = true
        
        self.indicatorView.addSubview(self.lottieAnimationView)
        self.indicatorContainer.addSubview(self.indicatorView)
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        window.addSubview(self.indicatorContainer)
        
        //MARK: - Add constraints
        self.indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.indicatorContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
            self.indicatorContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            self.indicatorView.heightAnchor.constraint(equalToConstant: self.length),
            self.indicatorView.widthAnchor.constraint(equalToConstant: self.length),
            self.indicatorView.centerYAnchor.constraint(equalTo: self.indicatorContainer.centerYAnchor),
            self.indicatorView.centerXAnchor.constraint(equalTo: self.indicatorContainer.centerXAnchor),
            
            self.lottieAnimationView.heightAnchor.constraint(equalToConstant: self.innerLength),
            self.lottieAnimationView.widthAnchor.constraint(equalToConstant: self.innerLength),
            self.lottieAnimationView.centerYAnchor.constraint(equalTo: self.indicatorView.centerYAnchor),
            self.lottieAnimationView.centerXAnchor.constraint(equalTo: self.indicatorView.centerXAnchor)
        ])
    }

    //MARK: - Action Methods -
    func show(isGif: Bool) {
        self.handleInitialView(animationName: "Loading")
        UIView.animate(withDuration: 0.3) {
            self.indicatorContainer.alpha = 1
        }
    }

    func dismiss() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        UIView.animate(withDuration: 0.2) {
            window.viewWithTag(self.tag)?.alpha = 0
        } completion: { _ in
            window.viewWithTag(self.tag)?.removeFromSuperview()
        }
    }
}
