//
//  BaseViewController.swift
// NewBase
//
//  Created by MGAbouarab on 30/12/2023.
//

import UIKit
import Combine
import Alamofire

class BaseViewController: UIViewController {
    
    var cancellables: Set<AnyCancellable> = []
    private var viewModel = BaseViewModel()
    
    //MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 26.0, *) {
            navigationItem.rightBarButtonItem?.hidesSharedBackground = true
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackTitle()
        view.backgroundColor = .textFieldBackground
        observeNotificationCount()

    }

    
    //   MARK: - Design -
    
    func setBackTitle(_ name: String? = nil, color: UIColor? = .black) {
        let backItem = UIBarButtonItem()
        backItem.title = name
        backItem.tintColor = color
        navigationItem.backBarButtonItem = backItem
        let customFont = UIFont.myMediumFont(ofSize: 18)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: customFont], for: .normal)
    }
    
    func changeNavigationBar(alpha: CGFloat) {
        self.navigationController?.navigationBar.subviews.first?.alpha = alpha
    }
    
    
    private func observeNotificationCount() {
           NotificationCenter.default.addObserver(
               self,
               selector: #selector(handleNotificationCount(_:)),
               name: .notificationCountUpdated,
               object: nil
           )
       }

       @objc private func handleNotificationCount(_ notification: Notification) {
           guard let count = notification.object as? Int else { return }
           updateNotificationCount(count)
       }
    
    
    //MARK: - Actions -
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - Deinit -
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(self.className) is deinit, No memory leak found")
    }
    
}
extension BaseViewController {
    func setNavigationBarColor(
        backgroundColor: UIColor,
        titleColor: UIColor = .white,
        prefersLargeTitles: Bool = false
    ) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = .clear
        
        if let backButtonImage = Language.isRTL()
            ? UIImage(named: "backArrow")
            : UIImage(named: "backArrow") {
            appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        }
        
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.boldSystemFont(ofSize: 26)
        ]
        
        // Apply appearance
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = titleColor
        navBar.prefersLargeTitles = prefersLargeTitles
    }
}

extension BaseViewController {
    func showIndicator() {
        LoaderManager.shared.show()
    }
    func hideIndicator() {
        LoaderManager.shared.hide()
    }
    @objc func endEditing() {
        self.view.endEditing(true)
    }
}

extension BaseViewController {
    
    //MARK: -Loading Binding-
    func loading(_ isLoading: Published<Bool>.Publisher){
        isLoading
            .dropFirst()
            .sinkOnMain{ [weak self] isLoading in
                guard let _ = self else {return}
                isLoading ? AppIndicator.shared.show(isGif: true) : AppIndicator.shared.dismiss()
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: -Error Binding-
    func error(_ error: Published<Error?>.Publisher){
        error
            .sinkOnMain{ [weak self] error in
                guard let self = self else {return}
                guard let error = error else {return}
                switch error.asAFError {
                case .sessionTaskFailed(error: _):
                    self.showErrorToast(with: "No internet connection, try later ......".localized)
                default:
                    handle(error: error)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: -Handle Error-
    func handle(error: Error) {
        if let responseError = error as? ResponseError {
            switch responseError {
            case .blocked:
                showWarningToast(with: "Your account has been blocked by admin".localized)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    AppHelper.blockUser()
                }
                
            case .unAuthorized:
                showWarningToast(with: "Your session has been expired,Please Login again".localized)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    AppHelper.blockUser()
                }
            default:
                self.showErrorToast(with: error.localizedDescription)
            }
        } else {
            self.showErrorToast(with: error.localizedDescription)
        }
    }
    
}

extension BaseViewController{
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func pop(animated: Bool = true, completion: @escaping () -> Void) {
        navigationController?.popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popToRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension BaseViewController {
    
    func show(successMessage message: String) {
        AlertManager.shared.show(message: message, type: .image(.init(systemName: SFSymbol.success.rawValue)))
    }
    func show(errorMessage message: String) {
        let message = message.replacingOccurrences(of: "URLSessionTask failed with error:", with: "")
        let errorImage: UIImage? = .init(systemName: SFSymbol.error.rawValue)?.withTintColor(.error, renderingMode: .alwaysOriginal)
        AlertManager.shared.show(message: message, type: .image(errorImage))
    }
    func show(favMessage message: String) {
        let favImage: UIImage? = .init(systemName: SFSymbol.favorite.rawValue)?.withTintColor(.warning, renderingMode: .alwaysOriginal)
        AlertManager.shared.show(message: message, type: .image(favImage))
    }
    
    func showRequiredLoginAlert() {
        self.presentCancelableAlert(
            title: "Login_alert_title".localized,
            message: "Login_alert_message".localized,
            actionTitle: "Login_alert_action_title".localized) { [weak self] in
                let vc = UIViewController()
                vc.view.backgroundColor = .main
                self?.present(vc, animated: true)
            }
    }
    
    func presentCancelableAlert(title: String, message: String, actionTitle: String, handler: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont.myBoldFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.label]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let messageAttributes = [NSAttributedString.Key.font: UIFont.myRegularFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let deleteAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
            handler()
        }
        let cancelAction = UIAlertAction(title: "alert_cancel_title".localized, style: .destructive)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = .main
        self.present(alert, animated: true)
    }
    
}
extension BaseViewController {
    
    // MARK: - Setup Notification Button with Badge -
    
    func setupNotificationButton() {
        if Session.isLogin ?? true {
            let notificationView = NotificationButtonView()
            
            notificationView.onTap = { [weak self] in
                self?.rightButtonTapped()
            }
            
            let barButtonItem = UIBarButtonItem(customView: notificationView)
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    func updateNotificationCount(_ count: Int) {
        (navigationItem.rightBarButtonItem?.customView as? NotificationButtonView)?
            .updateBadge(count: count)
    }
    
    @objc func rightButtonTapped() {
            let vc = NotificationVC(viewModel: NotificationVM())
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
    }
}
extension BaseViewController:ToastShower{}

