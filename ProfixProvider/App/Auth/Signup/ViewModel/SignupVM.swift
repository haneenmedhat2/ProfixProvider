//
//  SignupVM.swift
//  Esterad
//
//  Created by Haneen on 18/10/2025.
//

import Foundation
import Combine

protocol SignupVMProtocol {
    var signupPublisher: Published<BaseResponse<LoginResponse>?>.Publisher { get }
    var cityPublisher: Published<[CityModel]>.Publisher { get }
    var categoriesPublisher: Published<[Categories]>.Publisher { get }

    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var isChecked : Bool { get set }
    var citiesList : [CityModel] { get }
    var categoriesList : [Categories] { get }

    var selectedCity : SelectionModelPicker? { get set }
    var selectedCategories : [SelectionModelPicker]? { get set }
    var model : SignupModel? { get set }
    var currentPickerType: PickerType? { get set }

    func register(model: SignupModel)
    func getCities()
    func getCategories()
    func validateUserData(model: SignupModel)
}

final class SignupVM: BaseViewModel,SignupVMProtocol {
    
    @Published var signup: BaseResponse<LoginResponse>?
    @Published var citiesList: [CityModel] = []
    @Published var categoriesList: [Categories] = []
    
    @Published var validation: Error?
    
    var signupPublisher: Published<BaseResponse<LoginResponse>?>.Publisher { $signup }
    var cityPublisher: Published<[CityModel]>.Publisher { $citiesList}
    var categoriesPublisher: Published<[Categories]>.Publisher { $categoriesList }
    
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var isChecked : Bool = false
    var selectedCity : SelectionModelPicker?
    var selectedCategories : [SelectionModelPicker]?
    var model: SignupModel? = SignupModel()
    var currentPickerType: PickerType? = .city
    
    
    func register(model: SignupModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.signup(model: model, uploads: model.uploadData))
                isLoading = false
                signup = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getCities(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.getCities(countryId: 1))
                isLoading = false
                citiesList = result.data?.cities ?? []
                citiesList = citiesList.reversed()
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getCategories(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.getCategories())
                isLoading = false
                categoriesList = (result.data?.categories ?? []).filter { $0.status == "active" }
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
        
    }
    
    func validateUserData(model: SignupModel) {
        do {
            _ = try ValidationService.validate(providerName: model.name)
            _ = try ValidationService.validate(phone: model.phone)
            _ = try ValidationService.validate(categoryId: model.categoriesIds?.first)
            _ = try ValidationService.validate(visitPrice: model.visitRequestPrice)
            _ = try ValidationService.validate(cityId: selectedCity?.pickerId)
            _ = try ValidationService.validateLocation(address: model.address,lat: model.lat,long: model.long)
            _ = try ValidationService.validate(commercialFile: model.commercialFile)
            
            // Optional Bank Info Validation
            
            if let bankName = model.bankName, !bankName.isEmpty {
                _ = try ValidationService.validate(bankName: bankName)
            }
            
            if let bankOwner = model.bankOwnerName, !bankOwner.isEmpty {
                _ = try ValidationService.validate(bankAccountHolder: bankOwner)
            }
            
            if let accountNumber = model.bankAccountNumber, !accountNumber.isEmpty {
                _ = try ValidationService.validate(bankAccountNumber: accountNumber)
            }
            
            if let iban = model.bankIBANNumber, !iban.isEmpty {
                _ = try ValidationService.validate(iban: iban)
            }

            _ = try ValidationService.validate(password: model.password)
            _ = try ValidationService.validate(newPassword: model.password,confirmPassword: model.confrimPassword)
            _ = try ValidationService.validate(termesAgreed: isChecked)
            
            register(model: model)
            
        } catch {
            validation = error
        }
    }
}

