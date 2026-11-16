//
//  MyPreviousWorkVMProtocol.swift
//  ProfixProvider
//
//  Created by Haneen on 05/02/2026.
//


import Foundation
import Combine

protocol MyPreviousWorkVMProtocol {
    var previousWork: [Works] { get }
    var previousWorkPublisher: Published<[Works]>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
            
    func getWorksRequest()
}

final class MyPreviousWorkVM: BaseViewModel,MyPreviousWorkVMProtocol {
    
    @Published var previousWork: [Works] = []
    
    var previousWorkPublisher: Published<[Works]>.Publisher { $previousWork }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func getWorksRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getWorks())
                previousWork = result.data?.works ?? []
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
