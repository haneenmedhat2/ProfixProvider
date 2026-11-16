//
//  NewPhoneVM.swift
//  Profix
//
//  Created by Haneen on 23/12/2025.
//


import Foundation
import Combine

protocol NewPhoneVMProtocol {
    
    var newPhonePublisher: Published<BaseResponse<LoginResponse>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func newPhone(phone:String)
    func validateInputs(phone: String?)
}

final class NewPhoneVM: BaseViewModel,NewPhoneVMProtocol {
    
    @Published var newPhone: BaseResponse<LoginResponse>?
    @Published var validationError: Error?
    
    var newPhonePublisher: Published<BaseResponse<LoginResponse>?>.Publisher{ $newPhone}
    var validationPublisher: Published<Error?>.Publisher { $validationError }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func newPhone(phone:String){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.newPhone( phone: phone))
                isLoading = false
                newPhone = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateInputs(phone: String?) {
        
        do {
            let validatedNewPhone = try ValidationService.validate(newPhone: phone)
            newPhone(phone:validatedNewPhone)
        } catch {
            validationError = error
            
        }
    }
}
