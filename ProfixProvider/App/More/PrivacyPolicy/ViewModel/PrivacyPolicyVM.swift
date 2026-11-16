//
//  PrivacyPolicyVM.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//


import Foundation
import Combine

protocol PrivacyPolicyVMProtocol {

    var privacyPublisher: Published<BaseResponse<PrivacyPolicyResponse>?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
            
    func privacyPolicyRequest()
}

final class PrivacyPolicyVM: BaseViewModel,PrivacyPolicyVMProtocol {
    
    @Published var privacy: BaseResponse<PrivacyPolicyResponse>?
    
    var privacyPublisher: Published<BaseResponse<PrivacyPolicyResponse>?>.Publisher { $privacy }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func privacyPolicyRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.privacyPolicy())
                privacy = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
