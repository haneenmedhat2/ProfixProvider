//
//  ContactUsVMProtocol.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//


import Foundation
import Combine

protocol ContactUsVMProtocol {
    
    var contactUsPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var sitePhonePublisher: Published<BaseResponse<SitePhoneResponse>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }

    func validateInputs(model: ContactUsModel)
    func getSitePhone()
}

final class ContactUsVM: BaseViewModel,ContactUsVMProtocol {
    
    @Published var contactUs: BaseResponse<String>?
    @Published var sitePhone: BaseResponse<SitePhoneResponse>?
    @Published var validationError: Error?

    var contactUsPublisher: Published<BaseResponse<String>?>.Publisher { $contactUs }
    var sitePhonePublisher: Published<BaseResponse<SitePhoneResponse>?>.Publisher { $sitePhone }
    var validationPublisher: Published<Error?>.Publisher { $validationError }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }

    func getSitePhone() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.sitePhone())
                sitePhone = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    private func contactUs(model: ContactUsModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.contactUs(model: model))
                contactUs = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateInputs(model: ContactUsModel) {
        do {
            _ = try ValidationService.validate(message: model.message)
            
            let requestModel = ContactUsModel(
                message: model.message,
            )
            contactUs(model: requestModel)
        }catch{
            validationError = error
        }
    }
    
}
