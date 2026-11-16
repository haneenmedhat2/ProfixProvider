//
//  UpdateProfileVC.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import UIKit
import Combine
import Kingfisher

class UpdateProfileVC: BaseViewController {
    
    //MARK: - Outlets -

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var providerNameTextField: GeneralTextField!
    @IBOutlet weak var mainCategoryTextField: PickerFieldView!
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var bankNameTextField: GeneralTextField!
    @IBOutlet weak var bankHolderNameTextField: GeneralTextField!
    @IBOutlet weak var bankNumberTextField: GeneralTextField!
    @IBOutlet weak var IBANNumberTextField: GeneralTextField!
    @IBOutlet weak var ProviderBioTextView: DropDownTextView!
    @IBOutlet weak var visitPriceTextField: GeneralTextField!
    @IBOutlet weak var registrationNumTextField: FilePickerView!
    
    //MARK: - Properties -
    
    var viewModel : UpdateProfileVM

    //MARK: - Initializer -
    
    init(viewModel : UpdateProfileVM){
        self.viewModel = viewModel
        super.init(nibName: "UpdateProfileVC", bundle: nil)
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
        self.title = "edit_profile".localized
        configureProfileImage()
        setupUserData()
        viewModel.profileRequest()
        bindViewModel()
        cityTextField.delegate = self
        mainCategoryTextField.delegate = self

        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)
    }
    
    private func configureProfileImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCameraTap))
        profileImage.addGestureRecognizer(tap)

        let overlayImageView = UIImageView(image: UIImage(resource: .profilePic))
        overlayImageView.frame = profileImage.bounds
        overlayImageView.contentMode = .scaleAspectFit
        overlayImageView.alpha = 0.8
        overlayImageView.isUserInteractionEnabled = false

        profileImage.addSubview(overlayImageView)
    }
    
    func setupUserData() {
        guard let user = UserDefaults.user else { return }
        
        viewModel.selectedCity = CityModel(id: user.cityId, name: user.cityName)
        viewModel.selectedCategories = user.categories
        viewModel.model.address = user.address
        viewModel.model.lat = user.lat?.toDouble()
        viewModel.model.long = user.long?.toDouble()
        
        providerNameTextField.txtField.text = user.name
        mainCategoryTextField.txtField.text = user.categories?.compactMap{ $0.name }.joined(separator: "-")
        cityTextField.txtField.text = user.cityName
        locationTextField.txtField.text = user.address
        bankNameTextField.txtField.text = user.bankName
        bankHolderNameTextField.txtField.text = user.bankOwnerName
        bankNumberTextField.txtField.text = user.bankAccountNumber
        IBANNumberTextField.txtField.text = user.bankIbanNumber
        visitPriceTextField.txtField.text = user.visitRequestPrice
        registrationNumTextField.setRemoteFile(urlString: user.commercialFile)
        ProviderBioTextView.setText(user.bio ?? "")
        
        profileImage.kf.setImage(with: URL(string: user.avatar ?? ""),options: [.onFailureImage(UIImage(resource: .blankProfile )), .transition(.fade(0.3))])
    }

    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.updateProfilePublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                showLottiePopup(title: result.message)
            }
            .store(in: &cancellables)
        
        viewModel.profile
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                setupUserData()
            }
            .store(in: &cancellables)
        
        viewModel.cityPublisher
            .dropFirst()
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                self.showPickerPopup()
            }
            .store(in: &cancellables)

        viewModel.categoriesPublisher
            .dropFirst()
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                self.showPickerPopup()
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapConfirmUpdate(_ sender: UIButton) {
        viewModel.model.name = providerNameTextField.txtField.text
        viewModel.model.bio = ProviderBioTextView.actualText
        viewModel.model.bankName = bankNameTextField.txtField.text
        viewModel.model.bankOwnerName = bankHolderNameTextField.txtField.text
        viewModel.model.bankAccountNumber = bankNumberTextField.txtField.text
        viewModel.model.bankIbanNumber = IBANNumberTextField.txtField.text
        viewModel.model.visitRequestPrice = visitPriceTextField.txtField.text
        viewModel.model.commercialFile = registrationNumTextField.fileData
        viewModel.model.commercialFileName = registrationNumTextField.fileName
        viewModel.model.cityId = viewModel.selectedCity?.pickerId
        viewModel.model.categoryIds = viewModel.selectedCategories?.compactMap{$0.pickerId}

       viewModel.validateUserData()
    }
    
    @objc func onCameraTap(){
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, imageData in
            guard let self = self else { return }
            self.profileImage.image = image
            viewModel.model.avatar = imageData ?? Data()
        }
    }
    
    @objc func onLocationTapped(){
        goToBookingLocation()
    }
    
}

//MARK: - Routes -
extension UpdateProfileVC {
    
    func showPickerPopup() {
        let popup = PickerListPopup()
        switch viewModel.currentPickerType {

        case .city:
            popup.allowMultipleSelection = false
            popup.pickerList = viewModel.citiesList
            popup.selectedItem = viewModel.selectedCity
            popup.onItemSelected = { [weak self] item in
                guard let self else { return }
                self.viewModel.selectedCity = item
                self.cityTextField.txtField.text = item?.pickerName
            }

        case .category:
            popup.allowMultipleSelection = true
            popup.pickerList = viewModel.categoriesList

            popup.selectedItems = viewModel.selectedCategories ?? []
            popup.onItemsSelected = { [weak self] items in
                guard let self else { return }
                self.viewModel.selectedCategories = items
                self.mainCategoryTextField.txtField.text =
                items.map { $0.pickerName }.joined(separator: ", ")
            }

        default:
            return
        }
        popup.appear(sender: self)
    }
    
    func showLottiePopup(title: String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            pop()
        }
    }
    
    func goToBookingLocation(){
        let savedAddress: AddressModel?
        if let lat = viewModel.model.lat, let long = viewModel.model.long {
            savedAddress = AddressModel(
                lat: lat,
                long: long,
                desc: viewModel.model.address ?? ""
            )
        } else {
            savedAddress = nil
        }
        let bookingViewModel = BookingLocationVM(
            locationMode: .editLocation,
            selectedAddress: savedAddress
        )
        let vc = BookingLocationVC(viewModel: bookingViewModel)
        vc.viewModel.onLocationSelected = { [weak self ] address in
            guard let self = self else { return }
            self.locationTextField.txtField.text = address.desc
            self.viewModel.model.lat = address.lat
            self.viewModel.model.long = address.long
            self.viewModel.model.address = address.desc
           }
        
        push(vc, animated: true)
    }
}

//MARK: - Delegate Confirmation -
extension UpdateProfileVC : PickerFieldViewDelegate {
    
    func pickerFieldViewDidTap(_ view: PickerFieldView) {

        if view === cityTextField {
            viewModel.currentPickerType = .city

            if viewModel.citiesList.isEmpty {
                viewModel.getCities()
            } else {
                showPickerPopup()
            }

        } else if view === mainCategoryTextField {
            viewModel.currentPickerType = .category

            if viewModel.categoriesList.isEmpty {
                viewModel.getCategories()
            } else {
                showPickerPopup()
            }
        }
    }
}
