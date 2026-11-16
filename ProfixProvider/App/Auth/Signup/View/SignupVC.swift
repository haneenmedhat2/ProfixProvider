//
//  SignupVC.swift
//  Esterad
//
//  Created by Haneen on 18/10/2025.
//

import UIKit
import Combine

class SignupVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var providerNameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var mainCategoryTextField: PickerFieldView!
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var bankNameTextField: GeneralTextField!
    @IBOutlet weak var bankHolderNameTextField: GeneralTextField!
    @IBOutlet weak var bankNumberTextField: GeneralTextField!
    @IBOutlet weak var IBANNumberTextField: GeneralTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet weak var ProviderBioTextView: DropDownTextView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var visitPriceTextField: GeneralTextField!
    @IBOutlet weak var commercialFileTextField: FilePickerView!

    //MARK: - Properties -

    var viewModel : SignupVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : SignupVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "SignupVC", bundle: nil)
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
        self.title = "create_new_account".localized
        configureTextField()
        configureProfileImage()
        bindViewModel()
    }
    
    //MARK: - TextFields configurations -
    
    private func configureTextField(){
        cityTextField.delegate = self
        mainCategoryTextField.delegate = self

        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)
    }
    
    //MARK: - Image configurations -
    
    private func configureProfileImage() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCameraTap))
        profileImage.addGestureRecognizer(tap)
    }
    
    //MARK: - CheckBox Button  -
    
    private func updateCheckboxAppearance() {
        viewModel.isChecked.toggle()
        if viewModel.isChecked {
            checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        
        loading(viewModel.isLoadingPublisher)
        
        viewModel.signupPublisher
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                guard let result = result?.data else { return }
                goToVerification(model: result )
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
    
    //MARK: - Action -
    
    @IBAction func didTapCheckBox(_ sender: UIButton) {
        updateCheckboxAppearance()
    }
    
    @IBAction func didTapTermsAndConditions(_ sender: UIButton) {
        goToTermsAndConditions()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        goToLogin()
    }
    
    @IBAction func didTapSignup(_ sender: UIButton) {
 
        viewModel.validateUserData(model: SignupModel(name: providerNameTextField.txtField.text ,phone : phoneTextField.txtField.text,cityId: viewModel.selectedCity?.pickerId, password: passwordTextField.txtField.text ,confrimPassword: confirmPasswordTextField.txtField.text , lat: viewModel.model?.lat, long: viewModel.model?.long, address: viewModel.model?.address,bankName: bankNameTextField.txtField.text , bankOwnerName: bankHolderNameTextField.txtField.text , bankAccountNumber:bankNumberTextField.txtField.text , bankIBANNumber: IBANNumberTextField.txtField.text , visitRequestPrice: visitPriceTextField.txtField.text , commercialFile: commercialFileTextField.fileData , commercialFileName: commercialFileTextField.fileName , bio: ProviderBioTextView.actualText , categoriesIds: viewModel.selectedCategories?.compactMap{$0.pickerId} , avatar: viewModel.model?.avatar)  )
    }
    
    @objc func didTapChangeLanguage() {
        showLanguagePopup()
    }
    
    @objc func onCameraTap(){
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, imageData in
            guard let self = self else { return }
            self.profileImage.image = image
            viewModel.model?.avatar = imageData ?? Data()
            AppHelper.addDashedBorder( to: profileImage)
        }
    }
    
    @objc func onLocationTapped(){
        goToBookingLocation()
    }
}

//MARK: - Routes -

extension SignupVC {
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func goToLogin(){
        popToRoot()
    }
    
    func goToVerification(model : LoginResponse ){
        let vc = VerificationVC(viewModel: VerificationVM( model: model, flow: .signup))
        push(vc)
    }
    
    func goToTermsAndConditions(){
       let vc = TermsConditionsVC(viewModel: TermsVM())
       push(vc)
    }
    
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

    
    func goToBookingLocation(){
        let vc = BookingLocationVC(viewModel: BookingLocationVM(locationMode: .editLocation))
        vc.viewModel.onLocationSelected = { [weak self ] address in
            guard let self = self else { return }
            self.locationTextField.txtField.text = address.desc
            self.viewModel.model?.lat = address.lat
            self.viewModel.model?.long = address.long
            self.viewModel.model?.address = address.desc
           }
        
        push(vc, animated: true)
    }
}

//MARK: - Delegate Confirmation -

extension SignupVC : PickerFieldViewDelegate {

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

