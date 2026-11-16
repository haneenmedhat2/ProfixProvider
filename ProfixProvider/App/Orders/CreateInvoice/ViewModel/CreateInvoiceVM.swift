//
//  CreateInvoiceVM.swift
//  ProfixProvider
//
//  Created by Haneen on 10/02/2026.
//


import Foundation
import Combine

protocol CreateInvoiceVMProtocol {
    
    var createInvoicePublisher: Published<BaseResponse<String>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func createInvoiceRequest(service : String , price : String)
    func validateUserData(service : String? , price : String?)
    
    var orderId : Int { get }
    
}

final class CreateInvoiceVM: BaseViewModel,CreateInvoiceVMProtocol {
    
    @Published var createInvoice: BaseResponse<String>?
    @Published var validation: Error?
    
    var createInvoicePublisher: Published<BaseResponse<String>?>.Publisher  { $createInvoice }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var orderId : Int
    
    init(orderId : Int){
        self.orderId = orderId
    }

    func createInvoiceRequest(service : String , price : String) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.createInvoice(orderId: orderId, service: service, price: price))
                isLoading = false
                createInvoice = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData(service : String? , price : String?){
        do {
    
            let service = try ValidationService.validate(serviceName: service)
            let price = try ValidationService.validate(servicePrice: price)
            
            createInvoiceRequest(service : service , price : price)
            
        } catch {
            validation = error
        }
    }
}
