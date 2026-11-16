//
//  RoomsVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit
import Combine

class RoomsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Properties -
    
    var viewModel : RoomsVMProtocol
    private let refreshControl = UIRefreshControl()

    //MARK: - Initializer -
    
    init(viewModel :RoomsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "RoomsVC", bundle: nil)
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
    
    private func initialConfiguration(){
        self.title = "chats".localized
        viewModel.getRooms()
        configureTableView()
        bindToViewModel()
        setupNotificationButton()
        setupRefreshControl()
        searchTextField.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    //MARK: - ViewModel binding -
    
    private func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.chatRoomsPublisher
            .sinkOnMain { [weak self] result in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.searchSubject
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                if text.isEmpty {
                    viewModel.searchQuery = nil
                } else {
                    viewModel.searchQuery = text
                }
                viewModel.resetData()
                viewModel.getRooms()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Action -
    
    @objc private func searchChanged(_ textField: UITextField) {
        viewModel.searchSubject.send(textField.text ?? "")
    }
    
    @objc private func didPullToRefresh() {
        viewModel.resetData()
        viewModel.getRooms()
    }
}

//MARK: - TableView Configutations -

extension RoomsVC : UITableViewDelegate , UITableViewDataSource {
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: RoomCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.roomsList.isEmpty , separator: .none, style: .emptyChat)
        return viewModel.roomsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RoomCell.self, for: indexPath)
        let item = viewModel.roomsList[indexPath.row]
        cell.setupCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.roomsList[indexPath.row]
        let vc = ChatVC(viewModel: ChatVM(roomId: item.id ?? 0))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.roomsList.count - 1,
           !viewModel.isLastPage {
            viewModel.getRooms()
        }
    }
}

//MARK: - Routes -

extension RoomsVC {
    func goToNotification(){
      let vc = NotificationVC(viewModel: NotificationVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
