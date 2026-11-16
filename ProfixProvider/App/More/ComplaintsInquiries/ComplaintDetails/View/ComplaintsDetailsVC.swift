//
//  ComplaintsDetailsVC.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import UIKit
import Combine

class ComplaintsDetailsVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    var viewModel : ComplaintsDetailsVMProtocol

    //MARK: - Initializer -
    
    init(viewModel :ComplaintsDetailsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ComplaintsDetailsVC", bundle: nil)
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
        self.title = "complaint_details".localized
        viewModel.getComplaintsDetails()
        configureTableView()
    }
    
    //MARK: - ViewModel binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        viewModel.rowsPublisher
            .sinkOnMain { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
}

//MARK: - TableView Configutations -

extension ComplaintsDetailsVC : UITableViewDelegate , UITableViewDataSource {
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: ComplaintsDetailsCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ComplaintsDetailsCell.self, for: indexPath)
        cell.delegate = self
        let item = viewModel.rows[indexPath.row]
        let isLast = indexPath.row == (viewModel.rows.count - 1)
        cell.setupCell(model: item , isLastCell: isLast )
        return cell
    }
}

//MARK: - Cell Delefation -

extension ComplaintsDetailsVC : ComplaintsDetailsCellProtocol {
    func didSelectImage(url : String) {
        let vc = ImageViewerVC(viewModel: ImageViewerVM(image: .remote(url)))
        vc.appear(sender: self)
    }
}
