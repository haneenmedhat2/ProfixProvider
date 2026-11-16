//
//  SettingsVMProtocol.swift
//  Profix
//
//  Created by Haneen on 22/12/2025.
//


import Foundation
import Combine

protocol SettingsVMProtocol {
    
    var switchNotificationPublisher: Published<BaseResponse<SwitchNotification>?>.Publisher { get }
    var deleteAccountPublisher: Published<BaseResponse<String>?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var settingsItems : [MoreMenuItem] { get  }
    
    func changeLanguage(lang: String)
    func switchNotificationRequest()
    func deleteAccountRequest()
}

final class SettingsVM: BaseViewModel,SettingsVMProtocol {
    
    @Published var switchNotification: BaseResponse<SwitchNotification>?
    @Published var deleteAccount: BaseResponse<String>?

    
    var switchNotificationPublisher: Published<BaseResponse<SwitchNotification>?>.Publisher { $switchNotification }
    var deleteAccountPublisher: Published<BaseResponse<String>?>.Publisher { $deleteAccount }

    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var settingsItems: [MoreMenuItem] {
        return MoreMenuItem.settingsItems()
    }
            
    func changeLanguage(lang: String){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.changeLanguage())
                isLoading = false
                Session.user = result.data?.user
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func switchNotificationRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.switchNotification())
                isLoading = false
                switchNotification = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteAccountRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.deleteAccount())
                isLoading = false
                deleteAccount = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}

