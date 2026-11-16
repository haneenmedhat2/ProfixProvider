//
//  ComplaintsVC.swift
//  Profix
//
//  Created by Haneen on 25/12/2025.
//

import UIKit
import Combine

class ComplaintsVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var orderStateView: OrderStateView!
    
    //MARK: - Properties -
    
    var viewModel : ComplaintsVMProtocol
    private let refreshControl = UIRefreshControl()

    //MARK: - Initializer -
    
    init(viewModel :ComplaintsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ComplaintsVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        bindViewModel()
        self.title = "complaints_inquiries".localized
        configureTableView()
        viewModel.getOrderStatusList()
        orderStateView.getCollectionViewDataSource(collectionArray: viewModel.complaintsStatusList)
        viewModel.getComplaints()
        orderStateView.delegate = self
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    //MARK: - ViewModel binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        viewModel.complaintsPublisher
            .sinkOnMain { [weak self] user in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
  
    //MARK: - Action -

    @objc private func refreshData() {
        viewModel.getComplaints()
    }
    
    @IBAction func didTapAddComplaint(_ sender: UIButton) {
        let vc = AddNewComplaintVC(viewModel: AddNewComplaintsVM())
        vc.delegate = self
        push(vc)
    }
}

//MARK: - TableView Configutations -

extension ComplaintsVC : UITableViewDelegate , UITableViewDataSource {
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: OrderCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.complaintsList.isEmpty , separator: .none, style: .emptyComplaints)
        return viewModel.complaintsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OrderCell.self, for: indexPath)
        let item = viewModel.complaintsList[indexPath.row]
        cell.setupCell(id: item.id ?? 0, date: item.createdAt ?? "", statusText: item.status ?? "" , isOrder: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.complaintsList[indexPath.row]
        let vc = ComplaintsDetailsVC(viewModel: ComplaintsDetailsVM(id: item.id ?? 0))
        push(vc)
    }
}

//MARK: - Delegation -

extension ComplaintsVC : OrderStateViewDelegate , AddNewComplaintProtocol {
    func didSelectItem(at orderStatus: OrderStatus) {
        viewModel.status = orderStatus.apiValue
        viewModel.getComplaints()
    }
    
    func didAddNewComplaint(){
        viewModel.status = OrderStatus.open.apiValue
        viewModel.getComplaints()
    }
}
