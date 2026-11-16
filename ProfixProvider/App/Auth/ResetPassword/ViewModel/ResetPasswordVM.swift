//
//  ResetPasswordVM.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation
import Combine

protocol ResetPasswordVMProtocol {
    var resetPasswordPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var userToken : String { get }

    func resetPassword(password: String)
    func validateUserData( password : String? , confirmPassword : String?)

}

final class ResetPasswordVM : BaseViewModel , ResetPasswordVMProtocol {
    @Published var resetPassword: BaseResponse<String>?
    @Published var validation: Error?

    var resetPasswordPublisher: Published<BaseResponse<String>?>.Publisher { $resetPassword }
    var validationPublisher: Published<Error?>.Publisher { $validation }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var userToken : String

    init(userToken : String) {
        self.userToken = userToken
    }
    
    func resetPassword(password: String) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.resetPassword(password: password, token: userToken))
                isLoading = false
                resetPassword = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData( password : String? , confirmPassword : String?){
        do {
            let password = try ValidationService.validate(password: password)
            _ = try ValidationService.validate(newPassword: password, confirmPassword: confirmPassword)
            resetPassword(password: password )
            
        }catch{
            validation = error
        }
    }
}
