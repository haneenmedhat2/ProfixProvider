//
//  UpdateServiceVM.swift
//  ProfixProvider
//
//  Created by Haneen on 09/02/2026.
//


import Foundation
import Combine

protocol UpdateServiceVMProtocol {
    
    var updateServicePublisher: Published<BaseResponse<String>?>.Publisher { get }
    var categoriesPublisher: Published<[Categories]>.Publisher { get }
    var subcategoriesPublisher: Published<[SubCategoryModel]>.Publisher { get }
    
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var categoriesList : [Categories] { get }
    var subcategoriesList: [SubCategoryModel] { get }
    
    var selectedSubcategory : SelectionModelPicker? { get set }
    var selectedCategories : SelectionModelPicker? { get set }
    var currentPickerType: PickerType? { get set }
    var serviceDetails: Services { get }
    
    func updateServiceRequest(model: AddNewServiceModel)
    func getCategories()
    func subcategoryRequest()
    func validateUserData(model: AddNewServiceModel)
}

final class UpdateServiceVM: BaseViewModel,UpdateServiceVMProtocol {
    
    @Published var updateService: BaseResponse<String>?
    @Published var categoriesList: [Categories] = []
    @Published var subcategoriesList: [SubCategoryModel] = []
    
    @Published var validation: Error?
    
    var updateServicePublisher: Published<BaseResponse<String>?>.Publisher  { $updateService }
    var categoriesPublisher: Published<[Categories]>.Publisher { $categoriesList }
    var subcategoriesPublisher: Published<[SubCategoryModel]>.Publisher { $subcategoriesList }
    
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var selectedSubcategory : SelectionModelPicker?
    var selectedCategories : SelectionModelPicker?
    var model: SignupModel? = SignupModel()
    var currentPickerType: PickerType? = .category
    var serviceDetails: Services
    
    init(serviceDetails: Services ){
        self.serviceDetails = serviceDetails
    }
    
    func updateServiceRequest(model: AddNewServiceModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ServicesEndPoints.updateService(model: model))
                isLoading = false
                updateService = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func subcategoryRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ServicesEndPoints.getSubcategories(categoryId: selectedCategories?.pickerId ?? 0))
                isLoading = false
                self.subcategoriesList = result.data?.subcategories ?? []
                                
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
                let result = try await getAllRequest(ServicesEndPoints.getCategories())
                isLoading = false
                categoriesList = result.data?.categories ?? []
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData(model: AddNewServiceModel) {
        do {
            var updatedModel = model

            _ = try ValidationService.validate(categoryId: model.categoryId)
            _ = try ValidationService.validate(serviceID: model.subcategoryId )
            let price = try ValidationService.validate(servicePrice: model.price)
            _ = try ValidationService.validate(serviceDescription: model.decription)
            
            updatedModel.price = price
            updateServiceRequest(model: updatedModel)
            
        } catch {
            validation = error
        }
    }
}
