//
//  UpdateProfileVM.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import Foundation
import Combine

protocol UpdateProfileVMProtocol {
    
    var profile : PassthroughSubject<User,Never> { get }
    var updateProfilePublisher: Published<BaseResponse<ProfileResponseModel>?>.Publisher { get }
    var cityPublisher: Published<[CityModel]>.Publisher { get }
    var categoriesPublisher: Published<[Categories]>.Publisher { get }
    
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var citiesList : [CityModel] { get }
    var categoriesList : [Categories] { get }
    var model : UpdateProfileModel { get set }
    
    var selectedCity : SelectionModelPicker? { get set }
    var selectedCategories : [SelectionModelPicker]? { get set }
    var currentPickerType: PickerType? { get set }

    func getCities()
    func getCategories()
    func updateProfileRequest(model: UpdateProfileModel)
    func profileRequest()
    func validateUserData()
}

final class UpdateProfileVM: BaseViewModel,UpdateProfileVMProtocol {
    @Published var updateProfile: BaseResponse<ProfileResponseModel>?
    @Published var citiesList: [CityModel] = []
    @Published var categoriesList: [Categories] = []
    @Published var validation: Error?

    var profile: PassthroughSubject<User, Never> = .init()
    var updateProfilePublisher: Published<BaseResponse<ProfileResponseModel>?>.Publisher { $updateProfile }
    var cityPublisher: Published<[CityModel]>.Publisher { $citiesList}
    var categoriesPublisher: Published<[Categories]>.Publisher { $categoriesList }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var selectedCity : SelectionModelPicker?
    var selectedCategories : [SelectionModelPicker]?
    var currentPickerType: PickerType? = .city
    var model : UpdateProfileModel = UpdateProfileModel()

    func profileRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.profile(), progress: nil)
                guard let user = result.data?.user else { return }
                Session.user = user
                profile.send(user)
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func updateProfileRequest(model: UpdateProfileModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.updateProfile(model: model, uploads: model.uploadData))
                Session.user = result.data?.user
                updateProfile = result
                isLoading = false
                
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
                categoriesList = (result.data?.categories ?? [])
            } catch {
                isLoading = false
                self.error = error
            }
        }

    }
    
    func validateUserData() {
        do {
            _ = try ValidationService.validate(providerName: model.name)
            _ = try ValidationService.validate(categoryId: model.categoryIds?.first)
            _ = try ValidationService.validate(visitPrice: model.visitRequestPrice)
            _ = try ValidationService.validate(cityId: selectedCity?.pickerId)
            _ = try ValidationService.validateLocation(address: model.address,lat: model.lat,long: model.long)

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
            
            if let iban = model.bankIbanNumber, !iban.isEmpty {
                _ = try ValidationService.validate(iban: iban)
            }
            
            updateProfileRequest(model:model )
            
        } catch {
            validation = error
        }
    }
}
