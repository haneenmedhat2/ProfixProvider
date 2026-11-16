//
//  AboutUsVM.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//

import Foundation
import Combine

protocol AboutUsVMProtocol {

    var aboutUsPublisher: Published<BaseResponse<AboutUsResponse>?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
            
    func aboutUsRequest()
}

final class AboutUsVM: BaseViewModel,AboutUsVMProtocol {
    
    @Published var aboutUs: BaseResponse<AboutUsResponse>?
    
    var aboutUsPublisher: Published<BaseResponse<AboutUsResponse>?>.Publisher { $aboutUs }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func aboutUsRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.aboutUs())
                aboutUs = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
