//
//  MoreVMProtocol.swift
//  Profix
//
//  Created by Haneen on 21/12/2025.
//



import Foundation
import Combine

protocol MoreVMProtocol {
    var signout : PassthroughSubject<String,Never> { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var menuItems: [MoreMenuItem] { get }
    
    func signoutRequest()
}


final class MoreVM: BaseViewModel,MoreVMProtocol {
    var signout: PassthroughSubject<String, Never> = .init()

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    
    var menuItems: [MoreMenuItem] {
        return MoreMenuItem.moreItems()
    }
    
    func signoutRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.signout())
                signout.send(result.data ?? "")
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
