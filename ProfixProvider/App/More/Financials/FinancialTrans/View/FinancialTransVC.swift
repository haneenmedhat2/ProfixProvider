//
//  FinancialTransVC.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//

import UIKit

class FinancialTransVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var orderStateView: OrderStateView!
    
    //MARK: - Properties -
    
    var viewModel : FinancialTransVMProtocol
    private var pageViewController: UIPageViewController!

    private lazy var pages: [UIViewController] = {
        
        let dueVC = FinancialDueVC(viewModel: FinancialDueVM())
        let newDebtVC = NewFinancialTransVC(viewModel: NewFinancialTransVM(mode: .new))
        let finishedDebtVC = NewFinancialTransVC(viewModel: NewFinancialTransVM(mode: .finished))
        
        return [dueVC,newDebtVC,finishedDebtVC]
        }()

    //MARK: - Initializer -
    
    init(viewModel :FinancialTransVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "FinancialTransVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "financial_transactions".localized
        setupOrderStateView()
        setupPageViewController()
    }

    //MARK: - Initial Setup -

    private func setupOrderStateView() {
        orderStateView.getCollectionViewDataSource(collectionArray: viewModel.orderStatusList)
        orderStateView.delegate = self
    }
    
    private func setupPageViewController() {
            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

            addChild(pageViewController)
            view.addSubview(pageViewController.view)
            pageViewController.didMove(toParent: self)

            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageViewController.view.topAnchor.constraint(equalTo: orderStateView.bottomAnchor),
                pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
        }
}

//MARK: - Order State View Delegation -
extension FinancialTransVC: OrderStateViewDelegate {
    
    func didSelectItem(at orderType: OrderStatus) {
        let index: Int
        switch orderType {
        case .due: index = 0
        case .open: index = 1
        case .finished: index = 2
        default: return
        }
        changePage(to: index)
    }

    private func changePage(to newIndex: Int) {
        guard newIndex != viewModel.currentIndex else { return }

        let direction: UIPageViewController.NavigationDirection = newIndex > viewModel.currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([pages[newIndex]], direction: direction, animated: true)
        viewModel.currentIndex = newIndex
    }
    
    func navigateToDebtPage(index: Int) {
        changePage(to: index)
    }
}
