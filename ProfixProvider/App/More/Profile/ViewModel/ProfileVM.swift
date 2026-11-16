//
//  ProfileVM.swift
//  Esterad
//
//  Created by Haneen on 02/11/2025.
//

import Foundation
import Combine

protocol ProfileVMProtocol {
    var profile : PassthroughSubject<User,Never> { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    func profileRequest()
}

final class ProfileVM: BaseViewModel,ProfileVMProtocol {
    
    var profile: PassthroughSubject<User, Never> = .init()
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func profileRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.profile(), progress: nil)
                guard let user = result.data?.user else { return }
                Session.user = user
                profile.send(user)
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
