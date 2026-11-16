//
//  ForgetPasswordVM.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation
import Combine

protocol ForgetPasswordVMProtocol  {
    var forgetPasswordPublisher: Published<BaseResponse<LoginResponse>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func forgetPassword(phone: String)
    func validatePhone(phone: String?)

}

final class ForgetPasswordVM: BaseViewModel, ForgetPasswordVMProtocol {
    
    @Published var forgetPassword: BaseResponse<LoginResponse>?
    @Published var validationError: Error?

    var forgetPasswordPublisher: Published<BaseResponse<LoginResponse>?>.Publisher { $forgetPassword }
    var validationPublisher: Published<Error?>.Publisher { $validationError }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func forgetPassword(phone: String) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.forgetPassword(phone: phone))
                isLoading = false
                forgetPassword = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    
    func validatePhone(phone: String?) {
        
        do {
            let phoneNum = try ValidationService.validate(phone: phone)
            forgetPassword(phone: phoneNum)
            
        }catch{
            validationError = error
        }
    }
}
