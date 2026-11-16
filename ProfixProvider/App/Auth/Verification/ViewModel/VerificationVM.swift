//
//  VerificationVM.swift
//  Esterad
//
//  Created by Haneen on 19/10/2025.
//

import Foundation
import Combine

protocol VerificationVMProtocol {
    var verificationPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { get }
    
    var remainingTimePublisher: Published<Int>.Publisher { get }
    var isResendEnabledPublisher: Published<Bool>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var model : LoginResponse { get }
    var flow : VerificationFlow { get }
    
    func startCountdown()
    func validateOTP(otp : String?)
    func verificationRequest(code: String)
    func resendCodeRequest()
}

final class VerificationVM : BaseViewModel , VerificationVMProtocol {
    @Published var verification: BaseResponse<String>?
    @Published var resendCode: BaseResponse<String>?
    @Published var validation: Error?
    
    @Published private(set) var remainingTime: Int = 0
    @Published private(set) var isResendEnabled: Bool = true
    
    var verificationPublisher: Published<BaseResponse<String>?>.Publisher { $verification }
    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { $resendCode }
    var updateLocationPublisher: PassthroughSubject<BaseResponse<User>,Never> = .init()
    
    var remainingTimePublisher: Published<Int>.Publisher {$remainingTime}
    var isResendEnabledPublisher: Published<Bool>.Publisher { $isResendEnabled }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private var timer: Timer?
    private let baseTime = 60

    private var cancellables = Set<AnyCancellable>()
    
    var model : LoginResponse
    var flow : VerificationFlow
    
    init(model : LoginResponse, flow : VerificationFlow){
        self.model = model
        self.flow = flow
    }
    
    func startCountdown() {
        timer?.invalidate()
        isResendEnabled = false
        remainingTime = baseTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            
            if self.remainingTime <= 0 {
                stopCountdown()
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isResendEnabled = true
    }
    
    func validateOTP(otp : String?)  {
        do {
            let validatedOTP = try  ValidationService.validate(verificationCode: otp)
            verificationRequest(code : validatedOTP)
        }catch {
            validation = error
        }
    }
    
    func verificationRequest(code: String) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.verification(code: code, token: model.token ?? ""))
                isLoading = false
                verification = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func resendCodeRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.resendCode(token: model.token ?? ""))
                isLoading = false
                resendCode = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
