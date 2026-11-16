//
//  SpalshVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit

class SplashVC : BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet private weak var iconImage: UIImageView!
    private lazy var introViewModel = IntroVM()
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.isFirstTime {
            introViewModel.introRequest()
        }
        setupAnimation()
    }
    
    //MARK: - Initail Setup -
    
    private func setupAnimation() {
        iconImage.alpha = 0
        iconImage.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height / 4)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut) {
            self.iconImage.alpha = 1
            self.iconImage.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.goToNext()
        }
    }
}

//MARK: - Routes-

extension SplashVC {
    
    private func goToNext() {
        route(to: nextFlow())
    }
    
    private func nextFlow() -> AppFlow {
        if UserDefaults.isFirstTime {
            return .intro
        }
        return (Session.isLogin ?? false) ? .home :  .login
    }
    
    private func route( to flow : AppFlow){
        switch flow {
        case .intro:
            goToIntro()
        case .home:
            goToHome()
        case .login:
            goToLogin()
        }
    }
    
    private func goToIntro(){
        let vc = IntroViewController(viewModel : introViewModel)
        let nav = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
    
    private func goToHome(){
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    private func goToLogin(){
        let vc = LoginVC(viewModel: LoginVM())
        let nav  = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
}
