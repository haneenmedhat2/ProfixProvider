//
//  TermsVM.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//


import Foundation
import Combine

protocol TermsVMProtocol {

    var termsPublisher: Published<BaseResponse<TermsResponse>?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
            
    func termsRequest()
}

final class TermsVM: BaseViewModel,TermsVMProtocol {
    
    @Published var terms: BaseResponse<TermsResponse>?
    
    var termsPublisher: Published<BaseResponse<TermsResponse>?>.Publisher { $terms }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func termsRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.termsAndConditions())
                terms = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
