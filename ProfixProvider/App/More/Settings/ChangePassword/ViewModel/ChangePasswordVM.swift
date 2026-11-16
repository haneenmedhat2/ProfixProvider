//
//  ChangePasswordVM.swift
//  Profix
//
//  Created by Haneen on 24/12/2025.
//

import Foundation
import Combine

protocol ChangePasswordVMProtocol {
    
    var changePasswordPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func changePasswordRequest(model :ChangePasswordModel)
    func validateUserData(model :ChangePasswordModel)
}

final class ChangePasswordVM: BaseViewModel,ChangePasswordVMProtocol {
    
    @Published var changePassword: BaseResponse<String>?
    @Published var validation: Error?

    var changePasswordPublisher: Published<BaseResponse<String>?>.Publisher { $changePassword }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }

    func changePasswordRequest(model :ChangePasswordModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.changePassword(model:model))
                isLoading = false
                changePassword = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData(model :ChangePasswordModel) {
        
        do {
            _ = try  ValidationService.validate(oldPassword : model.currentPassword)
            _ = try ValidationService.validate(newPassword: model.password)
            _ = try ValidationService.validate(newPassword: model.password, confirmPassword: model.passwordConfirmation)
            changePasswordRequest(model: model)
            
        }catch{
            validation = error
        }
    }
}
