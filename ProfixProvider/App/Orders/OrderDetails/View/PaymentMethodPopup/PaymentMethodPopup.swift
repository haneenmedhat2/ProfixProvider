//
//  PaymentMethodPopup.swift
//  Profix
//
//  Created by Haneen on 18/01/2026.
//

import UIKit

class PaymentMethodPopup: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView : TableViewContentSized!
    
    //MARK: - Properties -
    
    private var selectedIndex: IndexPath?
    var selectedPayment : String?
    var paymentMethodsList : [PaymentMethodModel] = []
    var delegate : PaymentMethodPopupProtocol?
    
    //MARK: - Initializer  -
    
    init() {
        super.init(nibName: "PaymentMethodPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Configuration -
    
    func initialConfiguration(){
        configView()
        configureTableView()
    }
    
    //MARK: - View Configuration -
    
    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor  = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        contentView.isUserInteractionEnabled = true
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(onBackViewTapped))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(backTap)
    }

    func appear(sender:UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide(isDelegate: Bool){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false){
                if isDelegate {
                    self.delegate?.didSelectPaymentMethod(paymentMethod: self.selectedPayment ?? "")
                }
            }
            self.removeFromParent()
        }
    }
    
    func getDataSource(paymentMethodsList : [PaymentMethodModel]){
        self.paymentMethodsList = paymentMethodsList
        tableView.reloadData()
    }
        
    //MARK: - Actions -
    
    @IBAction func confirmlBtnTapped(_ sender: UIButton) {
        guard let _ = selectedPayment else {
            self.show(errorMessage : ValidationError.unselectedPaymentMethod.localizedDescription)
            return
        }
        self.hide(isDelegate: true)
    }
    
    @objc private func onBackViewTapped() {
        self.hide(isDelegate: false)
    }
}

//MARK: - TableView Configurations -
extension PaymentMethodPopup : UITableViewDataSource , UITableViewDelegate {
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: PaymentMethodCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethodsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: PaymentMethodCell.self, for: indexPath)
        let item = paymentMethodsList[indexPath.row]
        if item.isSelected {
            selectedIndex = indexPath
        }
        cell.setupCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let selectedIndex = selectedIndex {
                paymentMethodsList[selectedIndex.row].isSelected = false
                selectedPayment = nil
            }
        paymentMethodsList[indexPath.row].isSelected = true
            selectedIndex = indexPath
        selectedPayment =  paymentMethodsList[indexPath.row].key
        tableView.reloadData()
    }
}


//MARK: - Delegate Protocol -
protocol PaymentMethodPopupProtocol : AnyObject {
    func didSelectPaymentMethod(paymentMethod: String)
}
