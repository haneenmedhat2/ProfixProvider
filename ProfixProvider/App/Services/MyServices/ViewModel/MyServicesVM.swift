//
//  MyServicesVM.swift
//  ProfixProvider
//
//  Created by Haneen on 08/02/2026.
//


import Foundation
import Combine

protocol MyServicesVMProtocol {
    
    var services: [Services] { get }
    var servicesPublisher: Published<[Services]>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func getServices()
}

final class MyServicesVM: BaseViewModel,MyServicesVMProtocol {
    
    @Published var services: [Services] = []
    
    var servicesPublisher: Published<[Services]>.Publisher  { $services }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
     func getServices() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ServicesEndPoints.getServices())
                services = result.data?.services ?? []
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
