//
//  TermsOfUseVM.swift
//  Profix
//
//  Created by Haneen on 20/01/2026.
//


import Foundation
import Combine

protocol TermsOfUseVMProtocol {

    var termsPublisher: Published<BaseResponse<TermsOfUseResponse>?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
            
    func termsOfUseRequest()
}

final class TermsOfUseVM: BaseViewModel,TermsOfUseVMProtocol {
    
    @Published var terms: BaseResponse<TermsOfUseResponse>?
    
    var termsPublisher: Published<BaseResponse<TermsOfUseResponse>?>.Publisher { $terms }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func termsOfUseRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.termsOfUse())
                terms = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
