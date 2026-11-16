//
//  ProfileVC.swift
//  Esterad
//
//  Created by Haneen on 02/11/2025.
//

import UIKit
import Kingfisher
import Combine

class ProfileVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var providerNameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var mainCategoryTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: GeneralTextField!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var bankNameTextField: GeneralTextField!
    @IBOutlet weak var bankHolderNameTextField: GeneralTextField!
    @IBOutlet weak var bankNumberTextField: GeneralTextField!
    @IBOutlet weak var IBANNumberTextField: GeneralTextField!
    @IBOutlet weak var ProviderBioTextView: DropDownTextView!
    @IBOutlet weak var visitPriceTextField: GeneralTextField!
    @IBOutlet weak var registrationNumTextField: FilePickerView!
    
    //MARK: - Properties -
    
    let viewModel : ProfileVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : ProfileVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ProfileVC", bundle: nil)
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
    
    func initialConfiguration() {
        self.title = "profile".localized
        setupUserData()
        viewModel.profileRequest()
        bindViewModel()
        
        providerNameTextField.txtField.textColor = .hint
        phoneTextField.txtField.textColor = .hint
        mainCategoryTextField.txtField.textColor = .hint
        cityTextField.txtField.textColor = .hint
        locationTextField.txtField.textColor = .hint
        bankNameTextField.txtField.textColor = .hint
        bankHolderNameTextField.txtField.textColor = .hint
        bankNumberTextField.txtField.textColor = .hint
        IBANNumberTextField.txtField.textColor = .hint
        ProviderBioTextView.textView.textColor = .hint
        visitPriceTextField.txtField.textColor = .hint
        visitPriceTextField.txtField.textColor = .hint
        registrationNumTextField.isEditable = false

        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)

    }
    
    private func bindViewModel() {
        viewModel.profile
            .sinkOnMain { [weak self] user in
                guard let self = self else { return }
                self.setupUserData()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Actions -
    
    @objc func onLocationTapped(){
        goToBookingLocation()
    }
    
    //MARK: - Setup Data -
    
    func setupUserData() {
        guard let user = UserDefaults.user else { return }
        providerNameTextField.txtField.text = user.name
        phoneTextField.txtField.text = user.phone
        mainCategoryTextField.txtField.text = user.categories?.compactMap{ $0.name }.joined(separator: "-")
        cityTextField.txtField.text = user.cityName
        locationTextField.txtField.text = user.address
        visitPriceTextField.txtField.text = user.visitRequestPrice
        registrationNumTextField.setRemoteFile(urlString: user.commercialFile)

        
        if let bankName = user.bankName , !bankName.trimWhiteSpace().isEmpty {
            bankNameTextField.txtField.text = bankName
        } else {
            bankNameTextField.isHidden = true
        }
        
        if let bankHolderName = user.bankOwnerName , !bankHolderName.trimWhiteSpace().isEmpty {
            bankHolderNameTextField.txtField.text = bankHolderName
        } else {
            bankHolderNameTextField.isHidden = true
        }
        
        if let bankNum = user.bankAccountNumber , !bankNum.trimWhiteSpace().isEmpty {
            bankNumberTextField.txtField.text = bankNum
        } else {
            bankNumberTextField.isHidden = true
        }
        
        if let IBAN = user.bankIbanNumber , !IBAN.trimWhiteSpace().isEmpty {
            IBANNumberTextField.txtField.text = IBAN
        } else {
            IBANNumberTextField.isHidden = true
        }
        
        if let bio = user.bio , !bio.trimWhiteSpace().isEmpty {
            ProviderBioTextView.setText(bio)
        } else {
            ProviderBioTextView.isHidden = true
        }
        
        profileImage.kf.setImage(with: URL(string: user.avatar ?? ""),options: [.onFailureImage(UIImage(resource: .blankProfile )), .transition(.fade(0.3))])
    }
}


//MARK: - Routes -

extension ProfileVC {
    func goToBookingLocation(){
        let savedAddress = UserDefaults.user.flatMap { user -> AddressModel? in
            guard let lat = user.lat?.toDouble(), let long = user.long?.toDouble() else {
                return nil
            }
            return AddressModel(lat: lat, long: long, desc: user.address ?? "")
        }
        let viewModel = BookingLocationVM(
            locationMode: .profile,
            selectedAddress: savedAddress
        )
        let vc = BookingLocationVC(viewModel: viewModel)
        push(vc, animated: true)
    }
}
