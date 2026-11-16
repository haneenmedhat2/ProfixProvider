//
//  LoginVM.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import Foundation
import Combine

protocol LoginVMProtocol {
    
    var routePublisher: Published<LoginRoute?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func loginRequest(model: LoginModel)
    func validateInputs(model: LoginModel)
}

final class LoginVM: BaseViewModel,LoginVMProtocol {
    
    @Published var route: LoginRoute?
    @Published var validationError: Error?
    
    var routePublisher: Published<LoginRoute?>.Publisher { $route }
    var validationPublisher: Published<Error?>.Publisher { $validationError }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }

    private let analytics: LoginAnalyticsTracking
    private var isLoggingIn = false

    init(
        responseHandler: ResponseHandler = DefaultResponseHandler(),
        analytics: LoginAnalyticsTracking = AppAnalytics.shared
    ) {
        self.analytics = analytics
        super.init(responseHandler: responseHandler)
    }
    
    func loginRequest(model: LoginModel){
        guard !isLoggingIn else { return }
        isLoggingIn = true
        isLoading = true
        Task { @MainActor in
            defer {
                isLoggingIn = false
                isLoading = false
            }
            do {
                let result = try await getAllRequest(AuthEndpoints.login(model: model))
                try Task.checkCancellation()
                handleLoginResult(result)
            } catch {
                self.error = error
            }
        }
    }
    
    private func handleLoginResult(_ result: BaseResponse<LoginResponse>) {
        if result.key == .needActive {
            guard let response = result.data else { return }
            route = .verification(model: response)
            return
        }
        
        if result.key == .needApprove {
            route = .pendingApproval(msg: result.message)
            return
        }
        
        if result.key == .refused {
            route = .refused(msg: result.message)
            return
        }

        guard result.key == .success, let response = result.data else { return }
        Session.user = response.user
        Session.token = response.token
        analytics.login()
        
        if response.user.completedInfo == true {
            route = .home
        } else {
            route = .completeProfile
        }
    }
    
    func validateInputs(model: LoginModel) {
        
        do {
            _ = try ValidationService.validate(phone: model.phone)
            _ = try ValidationService.validate(password: model.password)
            loginRequest(model: model)
            
        }catch{
            validationError = error
        }
      }
}
