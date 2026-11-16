//
//  ActivateNewPhoneVM.swift
//  Profix
//
//  Created by Haneen on 23/12/2025.
//


import Foundation
import Combine

protocol ActivateNewPhoneProtocol {
    var phoneActivationPublisher: Published<BaseResponse<LoginResponse>?>.Publisher { get }
    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { get }
    
    var remainingTimePublisher: Published<Int>.Publisher { get }
    var isResendEnabledPublisher: Published<Bool>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }

    var phone : String { get }
    
    func startCountdown()
    func validateOTP(otp : String?)
    func activationRequest(code: String)
    func resendCodeRequest()
}

final class ActivateNewPhoneVM : BaseViewModel , ActivateNewPhoneProtocol {
    @Published var activation: BaseResponse<LoginResponse>?
    @Published var resendCode: BaseResponse<String>?
    @Published var validation: Error?
    
    @Published private(set) var remainingTime: Int = 0
    @Published private(set) var isResendEnabled: Bool = true
    
    var phoneActivationPublisher: Published<BaseResponse<LoginResponse>?>.Publisher { $activation }
    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { $resendCode }
    
    
    var remainingTimePublisher: Published<Int>.Publisher {$remainingTime}
    var isResendEnabledPublisher: Published<Bool>.Publisher { $isResendEnabled }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
        
    private var timer: Timer?
    private let baseTime = 60
    
    var phone : String
    
    init(phone : String){
        self.phone = phone
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func startCountdown() {
        timer?.invalidate()
        remainingTime = baseTime
        isResendEnabled = false

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.stopCountdown()
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isResendEnabled = true
    }
    
    func validateOTP(otp : String?){
        do {
            let validatedOTP = try  ValidationService.validate(verificationCode: otp)
            activationRequest(code : validatedOTP)

        }catch {
            validation = error
        }
    }
    
    func activationRequest(code: String) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.newPhoneActivation(code: code))
                Session.user = result.data?.user
                isLoading = false
                activation = result
                
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
                let result = try await getAllRequest(MoreEndpoints.resendNewPhoneCode( phone:phone ))
                isLoading = false
                resendCode = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
