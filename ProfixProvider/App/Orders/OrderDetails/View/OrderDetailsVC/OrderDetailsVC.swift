//
//  OrderDetailsVC.swift
//  Profix
//
//  Created by Haneen on 17/01/2026.
//

import UIKit
import Combine
import Kingfisher

class OrderDetailsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var orderNotesView: UIView!
    @IBOutlet weak var orderNotesLabel: UILabel!
    @IBOutlet weak var clientDetailsView: ClientDetailsView!
    @IBOutlet weak var orderDetailsView: OrderSummaryView!
    @IBOutlet weak var requestedServicesView: OrderSummaryView!
    @IBOutlet weak var problemDescView: ProblemDescView!
    @IBOutlet weak var geograpgicLocationView: GeographicLocationView!
    @IBOutlet weak var orderSummryView: OrderSummaryView!
    @IBOutlet weak var cancellationView: ContextView!
    @IBOutlet weak var feedbackView: ContextView!
    
    //Buttons
    
    @IBOutlet weak var acceptRefuseOrderBtnStackView: UIStackView!
    @IBOutlet weak var acceptRefuseDateBtnStackView: UIStackView!
    @IBOutlet weak var StartOrderButton: MainButton!
    @IBOutlet weak var finishOrderBtnStackView: UIStackView!
    @IBOutlet weak var lastFinishOrderBtn: MainButton!
    @IBOutlet weak var onTheWayButton: MainButton!
    @IBOutlet weak var arrivedToCustomerButton: MainButton!
    
    //MARK: - Properties -
    
    var viewModel : OrderDetailsVMProtocol
    private let acceptanceCountdownView = AcceptanceCountdownView()
    private var acceptanceCountdown: AcceptanceCountdown?
    private var countdownTimer: Timer?
    private var isScreenActive = false
    private var isScreenVisible = false
    private var hasShownPledge = false
    private weak var pledgePopup: PledgePopup?
    private let refreshControl = UIRefreshControl()
    
    private var chatUIButton: UIButton!
    private var reportUIButton: UIButton!
    private var billUIButton: UIButton!
    
    //MARK: - Initializer -
    
    init(viewModel :OrderDetailsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "OrderDetailsVC", bundle: nil)
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
        super.viewWillAppear(animated)
        isScreenVisible = true
        isScreenActive = UIApplication.shared.applicationState == .active
        if isScreenActive { viewModel.getOrderDetails() }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isScreenVisible = false
        suspendCountdown()
    }
    
    deinit {
        countdownTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        bindViewModel()
        self.title = "order_details".localized
        view.isHidden = true
        containerStackView.insertArrangedSubview(acceptanceCountdownView, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(isOrderChanged), name: .isOrderChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeCountdown), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(suspendCountdown), name: UIApplication.willResignActiveNotification, object: nil)
        setupRefreshControl()
        setupNavigationBar()
    }
    
    //MARK: - Navigation Bar Design -
    
    private func setupNavigationBar() {
        
        let chatButton = makeButton(
            image: UIImage(resource: .chat),
            action: #selector(didTapChatButton)
        )

        let reportButton = makeButton(
            image: UIImage(resource: .complaints),
            action: #selector(didTapReportButton)
        )

        let billButton = makeButton(
            image: UIImage(resource: .bill),
            action: #selector(didTapBillButton)
        )
        
        self.chatUIButton = chatButton
        self.reportUIButton = reportButton
        self.billUIButton = billButton
        
        let stack = UIStackView(arrangedSubviews: [
            chatButton,
            reportButton,
            billButton
        ])
        
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        
        let barItem = UIBarButtonItem(customView: stack)
        navigationItem.rightBarButtonItem = barItem
    }
    
    private func makeButton(image: UIImage, action: Selector) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
    private func setupRefreshControl(){
        if let scrollView = containerStackView.superview as? UIScrollView {
            scrollView.alwaysBounceVertical = true
            refreshControl.addTarget(self, action: #selector(isOrderChanged), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
    }
    
    //MARK: - ViewModel binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.orderDetailsPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                guard let result = result?.data?.order else { return }
                guard self.isScreenActive else { return }
                self.reconcileCountdown(model: result)
                self.viewSetup(model: result)
                self.handleShowButtonsAndViews(model : result)
                self.handleShowPledge(model : result)
                view.isHidden = false
                self.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.acceptOrderPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.viewModel.getOrderDetails()
            }
            .store(in: &cancellables)
        
        viewModel.rejectOrderPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                show(successMessage: result.message)
                goToHome()
            }
            .store(in: &cancellables)
        
        viewModel.acceptDatePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.viewModel.getOrderDetails()
            }
            .store(in: &cancellables)
        
        viewModel.rejectDatePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                show(successMessage: result.message)
                goToHome()
            }
            .store(in: &cancellables)
        
        viewModel.startOrderPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.viewModel.getOrderDetails()
            }
            .store(in: &cancellables)

        viewModel.onTheWayPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.viewModel.getOrderDetails()
            }
            .store(in: &cancellables)

        viewModel.arrivedToCustomerPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.viewModel.getOrderDetails()
            }
            .store(in: &cancellables)

        viewModel.finishOrderPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.showLottiePopup(title: result.message)
            }
            .store(in: &cancellables)
        
        viewModel.pledgePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                guard let self = self else { return }
                self.pledgePopup?.dismissAfterAcceptance()
                self.viewModel.getOrderDetails()
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.pledgePopup?.setSubmitting(false)
            }
            .store(in: &cancellables)
        
        
        error(viewModel.errorPublisher)
    }
    
    
    func viewSetup(model : OrderDetailsModel){
        clientDetailsView.setupData(model: model)
        orderDetailsView.getDataSource(model: model, type: .orderDetails)
        requestedServicesView.getDataSource(model: model, type: .requestedServices)
        requestedServicesView.isHidden = model.services?.isEmpty != false
        
        problemDescView.getDataSource(problemDesc: model.description ?? "", imageList: model.getProblemDescImages(), type: .orderDetails)
        problemDescView.delegate = self
        
        geograpgicLocationView.setupData(location: model.address ?? "", lat: model.lat?.toDouble() ?? 0.0, long: model.long?.toDouble() ?? 0.0 , type :.orderDetails)
        
        orderSummryView.getDataSource(model: model,type : .orderSummary)
        cancellationView.setupData(context: model.closeReason , cosmosValue: nil, type: .cancelReason)
        feedbackView.setupData(context: model.review?.comment , cosmosValue: model.review?.rate, type: .feedback)
        
        if model.status == .scheduled {
            orderNotesLabel.text = "client_requested_service_time_change".localized
        }
    }
    
    func handleShowPledge(model : OrderDetailsModel) {
        let pledge = model.pledge?.trimWhiteSpace() ?? ""
        guard !model.isPledgeHidden, model.pledgeSeen == false, !pledge.isEmpty, !hasShownPledge else { return }
        hasShownPledge = true
        showPledgePopup(content: pledge)
    }
    
    func handleShowButtonsAndViews(model : OrderDetailsModel) {
        cancellationView.isHidden = model.isCancelViewHidden
        feedbackView.isHidden = model.isFeedbackViewHidden
        orderNotesView.isHidden = model.isOrderNotesHidden
        acceptRefuseOrderBtnStackView.isHidden = model.isAcceptRejectOrderStackHidden
        acceptRefuseDateBtnStackView.isHidden = model.isAcceptRefuseDateStackHidden
        StartOrderButton.isHidden = model.isStartOrderBtnHidden
        finishOrderBtnStackView.isHidden = model.isFinishOrderBtnStackHidden
        lastFinishOrderBtn.isHidden = model.isLastFinishOrderHidden
        //chatUIButton.isHidden = model.isChatButtonHidden
        reportUIButton.isHidden = model.isComplaintButtonHidden
        billUIButton.isHidden = model.isBillButtonHidden
        onTheWayButton.isHidden = model.isOnTheWayToClientBtnHidden
        arrivedToCustomerButton.isHidden = model.isArrivedToClientBtnHidden
    }
    
    //MARK: - Action -
    
    @objc private func isOrderChanged() {
        guard isScreenActive else { return }
        viewModel.getOrderDetails()
    }

    private func reconcileCountdown(model: OrderDetailsModel) {
        stopCountdown()
        guard isScreenActive,
              let countdown = AcceptanceCountdown(seconds: model.acceptTimeoutTimer) else { return }
        acceptanceCountdown = countdown
        acceptanceCountdownView.configure(message: model.acceptTimeoutMessage)
        acceptanceCountdownView.update(seconds: countdown.remainingSeconds())
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.tickCountdown()
        }
        countdownTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func tickCountdown() {
        guard isScreenActive, let countdown = acceptanceCountdown else { return }
        let seconds = countdown.remainingSeconds()
        acceptanceCountdownView.update(seconds: seconds)
        if seconds == 0 {
            stopCountdown()
            viewModel.getOrderDetails()
        }
    }

    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        acceptanceCountdown = nil
        acceptanceCountdownView.isHidden = true
    }

    @objc private func suspendCountdown() {
        isScreenActive = false
        stopCountdown()
        viewModel.cancelOrderDetailsRequest()
        refreshControl.endRefreshing()
    }

    @objc private func resumeCountdown() {
        guard isScreenVisible, !isScreenActive else { return }
        isScreenActive = true
        viewModel.getOrderDetails()
    }
    
    @objc func didTapChatButton(){
        goToChat()
    }
    
    @objc func didTapReportButton(){
        goToComplaints()
    }
    
    @objc func didTapBillButton(){
        guard let url = viewModel.orderDetailsModel?.invoiceUrl else { return }
        showBillPopup(url: url)
    }
    
    @IBAction func didTapAcceptOrder(_ sender: UIButton) {
        viewModel.acceptOrderRequest()
    }
    
    @IBAction func didTapRejectOrder(_ sender: UIButton) {
        viewModel.rejectOrderRequest()
    }
    
    @IBAction func didTapAcceptDate(_ sender: UIButton) {
        viewModel.acceptDateRequest()
    }
    
    @IBAction func didTapRefuseDate(_ sender: UIButton) {
        viewModel.rejectDateRequest()
    }
    
    @IBAction func didTapStartOrder(_ sender: UIButton) {
        viewModel.startOrderRequest()
    }
    
    @IBAction func didTapCreateInvoice(_ sender: UIButton) {
        goToCreateInvoice()
    }
    
    @IBAction func didTapFinishOrder(_ sender: UIButton) {
        goToSecurityCodePopup()
    }
    
    @IBAction func didTapLastFinishOrder(_ sender: UIButton) {
        goToSecurityCodePopup()
    }
    
    @IBAction func didTapOnTheWay(_ sender: UIButton) {
        viewModel.onTheWayRequest()
    }


    @IBAction func didTapArrivedToCustomer(_ sender: UIButton) {
        viewModel.arrivedToCustomerRequest()
    }
    
}

//MARK: - Routes -

extension OrderDetailsVC {
    
    func goToChat(){
        let vc = ChatVC(viewModel: ChatVM(roomId:viewModel.orderDetailsModel?.roomId ?? 0))
        push(vc, animated: true)
    }
    
    func showBillPopup(url: String) {
        let vc = WebViewController()
        vc.urlString = url

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet  

        present(nav, animated: true)
    }
    
    func goToComplaints() {
        let tabBar = AppTabBarController()
        tabBar.selectedIndex = 4
        
        AppHelper.changeWindowRoot(vc: tabBar)
        if let moreNav = tabBar.viewControllers?[4] as? UINavigationController {
            let vc = AddNewComplaintVC(viewModel: AddNewComplaintsVM())
            vc.hidesBottomBarWhenPushed = true
            moreNav.pushViewController(vc, animated: true)
        }
    }
    
    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title, type: .normal)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getOrderDetails()
        }
    }
    
    func goToHome(){
        let tabBar  = AppTabBarController()
        tabBar.selectedIndex = 0
        AppHelper.changeWindowRoot(vc: tabBar)
    }
    
    func goToCreateInvoice(){
        let vc = CreateInvoiceVC(viewModel: CreateInvoiceVM(orderId: viewModel.orderId))
        push(vc, animated: true)
    }
    
    func goToSecurityCodePopup(){
        let popup = SecurityCodePopup()
        popup.delegate = self
        popup.appear(sender: self)
    }
    
    func showPledgePopup(content: String){
        let popup = PledgePopup()
        pledgePopup = popup
        popup.delegate = self
        popup.setupView(content: content)
        popup.appear(sender: self)
    }

}

//MARK: - Delegation -

extension OrderDetailsVC : ProblemDescViewDelegate , SecurityCodePopupProtocol, PledgePopupProtocol{
    
    func didSelectImage(_ image: ProblemDescImageType) {
        let vc = ImageViewerVC(viewModel: ImageViewerVM(image: image))
        vc.appear(sender: self)
    }
    
    func didTapConfirm(code: String) {
        viewModel.finsihOrderRequest(code: code)
    }
    
    func didAgreeToPledge() {
        viewModel.acceptPledge()
    }
}
