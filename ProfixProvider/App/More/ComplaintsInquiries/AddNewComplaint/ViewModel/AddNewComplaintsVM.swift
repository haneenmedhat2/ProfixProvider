//
//  ComplaintsVMProtocol.swift
//  Profix
//
//  Created by Haneen on 28/12/2025.
//


import Foundation
import Combine

protocol AddNewComplaintsVMProtocol {
    
    var createComplaintPublisher: Published<BaseResponse<AddComplaintsResponse>?>.Publisher  { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var validationPublisher: Published<Error?>.Publisher { get }
    var images : [Data] { get set }
    
    func createComplaint(model: AddComplaintsModel)
    func validateData(title : String? , desc: String?)
}

final class AddNewComplaintsVM: BaseViewModel,AddNewComplaintsVMProtocol {
    @Published var complaints : BaseResponse<AddComplaintsResponse>?
    @Published var validation: Error?
    
    var createComplaintPublisher: Published<BaseResponse<AddComplaintsResponse>?>.Publisher  { $complaints }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    var images : [Data] = []
    
    
    func createComplaint(model: AddComplaintsModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.addNewComplaint(model: model)
                )
                complaints = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateData(title : String? , desc: String?)  {
        do {
            let validatedTitle = try ValidationService.validate(complaintTitle: title)
            let validatedDesc = try ValidationService.validate(complaintDesc: desc)
            
            createComplaint(model: AddComplaintsModel(subject: validatedTitle, text: validatedDesc, delegateId: nil, images:images ))
        } catch {
            validation = error
        }
    }
}
