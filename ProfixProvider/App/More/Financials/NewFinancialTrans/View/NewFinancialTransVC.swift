//
//  NewFinancialTransVC.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit
import Combine

class NewFinancialTransVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    var viewModel : NewFinancialTransVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : NewFinancialTransVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "NewFinancialTransVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        switch viewModel.mode {
        case .new:
            viewModel.getNewSettlements()
            
        case .finished:
            viewModel.getFinishedSettlements()
        }
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        view.isHidden = true
        bindToViewModel()
        configureTableView()
    }
    
    func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.newSettlementsPublisher
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                view.isHidden = false
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}

//MARK: - TableView Configurations -

extension NewFinancialTransVC : UITableViewDataSource , UITableViewDelegate {
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: FinancialTransCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.newSettlements.isEmpty , separator: .none, style: .empySettlements)
        return viewModel.newSettlements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FinancialTransCell.self, for: indexPath)
        let item = viewModel.newSettlements[indexPath.row]
        cell.setupCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.newSettlements[indexPath.row]
        let vc = FinancialTransDetailsVC(viewModel: FinancialDetailsVM(id: item.id ?? 0))
        push(vc)
    }
}
