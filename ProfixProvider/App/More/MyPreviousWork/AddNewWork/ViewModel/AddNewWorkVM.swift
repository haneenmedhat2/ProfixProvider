//
//  AddNewWorkVM.swift
//  ProfixProvider
//
//  Created by Haneen on 27/01/2026.
//


import Foundation
import Combine

protocol AddNewWorkVMProtocol {
    
    var addWorkPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    var categoriesPublisher: Published<[Categories]>.Publisher { get }
    var categoriesList: [Categories] { get }
    var selectedCategory: SelectionModelPicker? { get set }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var mode : AddNewWorkMode { get }
    var workId : Int?  { get }
    var existingWork: Works? { get }
    
    func addNewWorkRequest(model : AddNewWorkModel)
    func validateImage(model : AddNewWorkModel)
    func getCategories()
}

final class AddNewWorkVM: BaseViewModel,AddNewWorkVMProtocol {
    
    @Published var addWork: BaseResponse<String>?
    @Published var validationError: Error?
    @Published var categoriesList: [Categories] = []
    var selectedCategory: SelectionModelPicker?
    var categoriesPublisher: Published<[Categories]>.Publisher { $categoriesList }

    var addWorkPublisher: Published<BaseResponse<String>?>.Publisher { $addWork }
    var validationPublisher: Published<Error?>.Publisher { $validationError }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var mode : AddNewWorkMode
    var workId : Int?
    let existingWork: Works?
    init(mode : AddNewWorkMode, workId : Int?, existingWork: Works? = nil){
        self.mode = mode
        self.workId = workId
        self.existingWork = existingWork
    }
    
    func getCategories() {
        guard !isLoading else { return }
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

    func addNewWorkRequest(model : AddNewWorkModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.addNewWork(model: model))
                isLoading = false
                addWork = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func updateWorkRequest(model : UpdateWorkModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.updateWork(model: model))
                isLoading = false
                addWork = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    
    func validateImage(model : AddNewWorkModel) {
        
        do {
            _ = try ValidationService.validate(image: model.image)
            switch mode {
            case .completeInfo ,.newItem:
                _ = try ValidationService.validate(categoryId: model.categoryId)
                addNewWorkRequest(model : model)
            case .updateItem:
                updateWorkRequest(model: UpdateWorkModel(image: model.image, workId: workId))
            }
            
        }catch {
            validationError = error
        }
      }
}
