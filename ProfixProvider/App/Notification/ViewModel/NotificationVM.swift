//
//  NotificationVM.swift
//  Profix
//
//  Created by Haneen on 09/12/2025.
//


import Foundation
import Combine

protocol NotificationVMProtocol {
    
    var notificationPublisher: Published<BaseResponse<NotificationResponse>?>.Publisher { get }
    var deleteNotificationPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var deleteAllPublisher: Published<BaseResponse<String>?>.Publisher { get }

    var validationPublisher: Published<ValidationError?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var notificationList : [NotificationModel] { get }
    var currentPage : Int { get }
    var isLastPage: Bool { get }
    var isDeleteAllHidden : Bool { get }
    
    func getNotification()
    func deleteNotificationRequest(notificationId: String)
    func deleteAllNotifications()
    func resetData()
}

final class NotificationVM: BaseViewModel,NotificationVMProtocol {
    
    @Published var notification: BaseResponse<NotificationResponse>?
    @Published var deleteNotification: BaseResponse<String>?
    @Published var deleteAllNotification: BaseResponse<String>?

    @Published var validationError: ValidationError?

    var notificationPublisher: Published<BaseResponse<NotificationResponse>?>.Publisher { $notification }
    var deleteNotificationPublisher: Published<BaseResponse<String>?>.Publisher { $deleteNotification }
    var deleteAllPublisher: Published<BaseResponse<String>?>.Publisher { $deleteAllNotification }

    var validationPublisher: Published<ValidationError?>.Publisher { $validationError }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var notificationList : [NotificationModel] = []
    var currentPage:Int = 1
    var isLastPage: Bool = false
    var isDeleteAllHidden : Bool = false

    func getNotification(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(NotificationsEndPoints.getNotifications(page: currentPage))
                
                let notificationList = result.data?.notifications ?? []
                
                if currentPage == 1 {
                    self.notificationList.removeAll()
                    self.notificationList = notificationList
                } else {
                    self.notificationList.append(contentsOf: notificationList)
                }
                
                isLastPage = result.data?.pagination.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                
                isLoading = false
                isDeleteAllHidden = notificationList.isEmpty
                notification = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteNotificationRequest(notificationId: String){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(NotificationsEndPoints.deleteNotification( id: notificationId))
                resetData()
                getNotification()
                isLoading = false
                deleteNotification = result
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteAllNotifications(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(NotificationsEndPoints.deleteAll())
                resetData()
                getNotification()
                isLoading = false
                deleteAllNotification = result
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func resetData(){
        currentPage = 1
        isLastPage = false
    }
}
