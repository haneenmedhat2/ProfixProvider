//
//  PickerListPopup.swift
//  Esterad
//
//  Created by Haneen on 17/11/2025.
//

import UIKit

class PickerListPopup: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    var pickerList: [SelectionModelPicker] = []
    var selectedItem: SelectionModelPicker?
    var selectedItems: [SelectionModelPicker] = []
    var onItemSelected: ((SelectionModelPicker?) -> Void)?
    var onItemsSelected: (([SelectionModelPicker]) -> Void)?
    var allowMultipleSelection: Bool = false
    
    //MARK: - Initializer  -
    
    init() {
        super.init(nibName: "PickerListPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func hide(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false){
                
            }
            self.removeFromParent()
        }
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        if allowMultipleSelection {
            onItemsSelected?(selectedItems)
        } else {
            onItemSelected?(selectedItem)
        }
        hide()
    }
    
    @objc private func onBackViewTapped() {
        self.hide()
    }
}

// MARK: - UITableView Configuration  -
extension PickerListPopup: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.register(cellType: PickerListCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pickerList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(with: PickerListCell.self, for: indexPath)
        let item = pickerList[indexPath.row]
        let isSelected: Bool

        if allowMultipleSelection {
            isSelected = selectedItems.contains(where: {
                $0.pickerId == item.pickerId
            })
        } else {
            isSelected = item.pickerId == selectedItem?.pickerId
        }
        cell.setupCell(model: item, isSelected: isSelected)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let value = pickerList[indexPath.row]

        if allowMultipleSelection {
            if let index = selectedItems.firstIndex(where: {
                $0.pickerId == value.pickerId
            }) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(value)
            }

        } else {
            if selectedItem?.pickerId == value.pickerId {
                selectedItem = nil
            } else {
                selectedItem = value
            }
        }

        tableView.reloadData()
    }
}
