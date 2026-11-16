//
//  AddNewServiceVM.swift
//  ProfixProvider
//
//  Created by Haneen on 08/02/2026.
//


import Foundation
import Combine

protocol AddNewServiceVMProtocol {
    
    var addServicePublisher: Published<BaseResponse<String>?>.Publisher { get }
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
    
    func addServiceRequest(model: AddNewServiceModel)
    func getCategories()
    func subcategoryRequest()
    func validateUserData(model: AddNewServiceModel)
}

final class AddNewServiceVM: BaseViewModel,AddNewServiceVMProtocol {
    
    @Published var addService: BaseResponse<String>?
    @Published var categoriesList: [Categories] = []
    @Published var subcategoriesList: [SubCategoryModel] = []
    
    @Published var validation: Error?
    
    var addServicePublisher: Published<BaseResponse<String>?>.Publisher  { $addService }
    var categoriesPublisher: Published<[Categories]>.Publisher { $categoriesList }
    var subcategoriesPublisher: Published<[SubCategoryModel]>.Publisher { $subcategoriesList }
    
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var selectedSubcategory : SelectionModelPicker?
    var selectedCategories : SelectionModelPicker?
    var model: SignupModel? = SignupModel()
    var currentPickerType: PickerType? = .category

    private let analytics: ServiceAnalyticsTracking
    private var isAddingService = false
    private var hasAddedService = false

    init(
        responseHandler: ResponseHandler = DefaultResponseHandler(),
        analytics: ServiceAnalyticsTracking = AppAnalytics.shared
    ) {
        self.analytics = analytics
        super.init(responseHandler: responseHandler)
    }
    
    func addServiceRequest(model: AddNewServiceModel) {
        guard !isAddingService, !hasAddedService else { return }
        isAddingService = true
        isLoading = true
        Task { @MainActor in
            defer {
                isAddingService = false
                isLoading = false
            }
            do {
                let result = try await getAllRequest(ServicesEndPoints.addNewService(model: model))
                try Task.checkCancellation()
                guard result.key == .success else {
                    throw ResponseError.server(message: result.message)
                }
                hasAddedService = true
                analytics.serviceAdded()
                addService = result
                
            } catch {
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
            
            _ = try ValidationService.validate(categoryId: updatedModel.categoryId)
            _ = try ValidationService.validate(serviceID: updatedModel.subcategoryId)
            let price = try ValidationService.validate(servicePrice: updatedModel.price)
            _ = try ValidationService.validate(serviceDescription: updatedModel.decription)
            
            updatedModel.price = price
            
            addServiceRequest(model: updatedModel)
            
        } catch {
            validation = error
        }
    }
}
