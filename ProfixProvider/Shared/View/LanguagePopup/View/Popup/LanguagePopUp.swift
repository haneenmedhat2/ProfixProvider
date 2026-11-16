//
//  LanguagePopUp.swift
//  Waraqa
//
//  Created by Haneen on 04/08/2025.
//

import UIKit

class LanguagePopUp: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView : TableViewContentSized!
    
    //MARK: - Properties -
    
    private var selectedIndex: IndexPath?
    var selectedLanguage : String?
    var languageList : [LanguageModel] = LanguageModel.getLanguageList()
    let viewModel = SettingsVM()
    
    //MARK: - Initializer  -
    
    init() {
        super.init(nibName: "LanguagePopUp", bundle: nil)
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
        self.contentView.layer.cornerRadius = 16
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
    
    @IBAction func confirmlBtnTapped(_ sender: UIButton) {
        guard let language = selectedLanguage else {
            self.show(errorMessage : ValidationError.unselectedLanguage.localizedDescription)
            return
        }
        if language != Language.apiLanguage() {
            UserDefaults.languageChanged = true
            openAppSettings()
        }
        self.hide()
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
    
    @objc private func onBackViewTapped() {
        self.hide()
    }
}

//MARK: - TableView Configurations -
extension LanguagePopUp : UITableViewDataSource , UITableViewDelegate {
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: LanguageCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: LanguageCell.self, for: indexPath)
        let item = languageList[indexPath.row]
        if item.isSelected {
            selectedIndex = indexPath
            selectedLanguage =  languageList[indexPath.row].apiValue
        }
        cell.setupCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndex {
            languageList[selectedIndex.row].isSelected = false
            selectedLanguage = nil
        }
        languageList[indexPath.row].isSelected = true
        selectedIndex = indexPath
        selectedLanguage =  languageList[indexPath.row].apiValue
        tableView.reloadData()
    }
}
