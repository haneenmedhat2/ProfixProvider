//
//  ChatVC.swift
//  Esterad
//
//  Created by Haneen on 07/12/2025.
//

import UIKit
import Combine

class ChatVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var msgTextView: AppTextView!
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: - Properties -
    
    var viewModel : ChatVMProtocol
    var delegate : ChatDelegateProtocol?
    private var socketManager: ChatSocketConnection?
    
    //MARK: - Initializer -
    
    init(viewModel :ChatVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ChatVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socketManager?.exitChat(completion: nil)
    }
    
    deinit {
          NotificationCenter.default.removeObserver(self, name: .appDidBecomeActive, object: nil)
    }
    
    //MARK: - Initial Setup -
    
    private func initialConfiguration(){
        self.title = "conversation".localized
        configureTableView()
        bindToViewModel()
        viewModel.getSingleRoom()
        msgTextView.textView.delegate = self
        navigationItem.rightBarButtonItem = makeComplaintButton()
            
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshData),
            name: .appDidBecomeActive,
            object: nil
        )
    }
    
    private func makeComplaintButton() -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .complaints), for: .normal)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        button.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    
    //MARK: - ViewModel binding -
    
    private func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        
        viewModel.singleRoomPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                guard let result = result?.data?.room else { return }
                self.handleMessageBar(status : result.status ?? "")
                self.tableView.reloadData()
                self.configureSocket(data: result)
            }
            .store(in: &cancellables)
        
        viewModel.uploadFilePublisher
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                guard let result = result?.data else { return }
                self.socketManager?.sendMessage(messageType: .image(path: result.name ?? ""), completion: nil)
            }
            .store(in: &cancellables)
        
        viewModel.isSendEnabled
            .sinkOnMain { [weak self] isEnabled in
                guard let self = self else { return }
                self.sendButton.isEnabled = isEnabled
                self.sendButton.alpha = isEnabled ? 1 : 0.4
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    func handleMessageBar(status : String){
        if status == "finished" {
            buttonView.isHidden = true
            //buttonView.backgroundColor = .clear
        }
    }
    
    //MARK: - Action -
    
    
    @IBAction func didTapSend(_ sender: UIButton) {
        guard let message = msgTextView.textValue() , !message.trimWhiteSpace().isEmpty else {
            show(errorMessage: "Please enter your messsage first".localized)
            return }
        
        socketManager?.sendMessage(messageType: .text(value: message), completion: nil)
        msgTextView.set(text: nil)
    }
    
    @IBAction func didTapAddImage(_ sender: UIButton) {
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, imageData in
            guard let self = self else { return }
            guard let data = imageData else { return }
            viewModel.uploadFileRequest(model: UploadFileModel(file: data, type: "image"))
        }
    }
    
    @objc private func handleExitChatNotification(_ notification: Notification) {
        delegate?.didExitChat()
        pop(animated: true)
    }
    
    @objc func refreshData(){
        viewModel.resetData()
        viewModel.getSingleRoom()
    }
    
    @objc func didTapReportButton(){
        goToComplaints()
    }
}

//MARK: - TableView Configutations -

extension ChatVC : UITableViewDelegate , UITableViewDataSource {
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: ReceiverCell.self)
        tableView.register(cellType: SenderCell.self)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .interactiveWithAccessory
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.messagesList[indexPath.row]
        if item.sentByMe ?? true {
            let cell = tableView.dequeueReusableCell(with: SenderCell.self, for: indexPath)
            cell.setupCell(model: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: ReceiverCell.self, for: indexPath)
            cell.setupCell(model: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.messagesList[indexPath.row]
        if item.type == "image" {
            let vc = ImageViewerVC(viewModel: ImageViewerVM(image: .remote(item.content ?? "")))
            vc.appear(sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.messagesList.count - 1,
           !viewModel.isLastPage {
            viewModel.getSingleRoom()
        }
    }
}

// MARK:  - Handle socket -

extension ChatVC {
    
    private func configureSocket(data: SingleRoomModel) {
        socketManager = .init(conversationId: "\(viewModel.roomId)",
                              sender: data.getSenderData(),
                              receiver: data.getReceiverData(id: viewModel.delegateId ?? 0 ))
        socketManager?.start()
        
        socketManager?.onMessageReceived = { [weak self] message in
            guard let self else { return }
            self.addNewMessage(message)
        }
    }
    
    private func addNewMessage(_ socketMessage: ChatSocketConnection.Message) {
        insertNewMessage(
            ChatMessage(
                id: Int(socketMessage.id) ?? 0,
                content: socketMessage.type.messageBodyValue,
                duration: 0,
                avatar:  socketMessage.avatar,
                type: socketMessage.type.socketValue.rawValue,
                date:  socketMessage.createdAt,
                time: socketMessage.time,
                sentByMe: socketMessage.isSender
            )
        )
    }
    
    func insertNewMessage(_ newMessage: ChatMessage) {
        viewModel.messagesList.insert(newMessage, at: 0)
        tableView.reloadData()
        tableView.scrollToTop(animated: true)
    }
}


//MARK: - Delegate Protocol -
protocol ChatDelegateProtocol : AnyObject {
    func didExitChat()
}

//MARK: - TextView Delegation -
extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        msgTextView.set(text: textView.text)
        viewModel.messageText.send(textView.text)
    }
}

//MARK: - Routes -
extension ChatVC {
    
    func goToComplaints() {
        let tabBar = AppTabBarController()
        tabBar.selectedIndex = 3
        
        AppHelper.changeWindowRoot(vc: tabBar)
        if let moreNav = tabBar.viewControllers?[3] as? UINavigationController {
            let vc = AddNewComplaintVC(viewModel: AddNewComplaintsVM())
            vc.hidesBottomBarWhenPushed = true
            moreNav.pushViewController(vc, animated: true)
        }
    }
}
