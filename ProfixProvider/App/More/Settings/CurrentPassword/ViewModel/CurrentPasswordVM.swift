//
//  CurrentPasswordVM.swift
//  Profix
//
//  Created by Haneen on 23/12/2025.
//


import Foundation
import Combine

protocol CurrentPasswordVMProtocol {
    
    var currentPasswordPublisher: Published<BaseResponse<CurrentPasswordResponse>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func checkPassword(password:String)
    func validateInputs(password: String?)
}

final class CurrentPasswordVM: BaseViewModel,CurrentPasswordVMProtocol {
    
    @Published var currentPassword: BaseResponse<CurrentPasswordResponse>?
    @Published var validationError: Error?

    var currentPasswordPublisher: Published<BaseResponse<CurrentPasswordResponse>?>.Publisher { $currentPassword }
    var validationPublisher: Published<Error?>.Publisher { $validationError }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func checkPassword(password:String){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.checkPassword(password: password))
                isLoading = false
                currentPassword = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateInputs( password: String?)  {

        do {
           let password = try  ValidationService.validate(oldPassword :password)
            checkPassword(password: password)
            
        }catch{
            validationError = error
        }
      }
}
