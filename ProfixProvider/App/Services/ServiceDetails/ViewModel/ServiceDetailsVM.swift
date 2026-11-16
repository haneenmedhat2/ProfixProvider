//
//  ServiceDetailsVM.swift
//  ProfixProvider
//
//  Created by Haneen on 09/02/2026.
//



import Foundation
import Combine

protocol ServiceDetailsVMProtocol {
    
    var serviceDetails: Services? { get }
    var serviceDetailsPublisher: Published<Services?>.Publisher { get }
    var deleteServicePublisher: Published<BaseResponse<String>?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var serviceId : Int { get }
    func getServiceDetails()
    func deleteServiceRequest()
}

final class ServiceDetailsVM: BaseViewModel,ServiceDetailsVMProtocol {
    
    @Published var serviceDetails: Services?
    @Published var deleteService: BaseResponse<String>?
    
    var serviceDetailsPublisher: Published<Services?>.Publisher { $serviceDetails }
    var deleteServicePublisher: Published<BaseResponse<String>?>.Publisher { $deleteService}
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var serviceId : Int
    init( serviceId : Int){
        self.serviceId = serviceId
    }
    
    func getServiceDetails() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ServicesEndPoints.getServiceDetails(serviceId: serviceId))
                serviceDetails = result.data?.service
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteServiceRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ServicesEndPoints.deleteService(serviceId: serviceId))
                deleteService = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
}
