//
//  NotificationCountManager.swift
//  Profix
//
//  Created by Haneen on 16/12/2025.
//

import Foundation
import UIKit

final class NotificationCountManager {

    static let shared = NotificationCountManager()

    private init() {}

    private let viewModel = NotificationCountViewModel()

    private(set) var count: Int = 0 {
        didSet {
            NotificationCenter.default.post(
                name: .notificationCountUpdated,
                object: count
            )
        }
    }
    
    func markAllAsRead() {
        count = 0
    }

    func refresh() {
        Task {
            do {
                let newCount = try await viewModel.fetchCount()
                await MainActor.run {
                    self.count = newCount
                }

            } catch {
                count = 0
            }
        }
    }
}


extension Notification.Name {
    static let notificationCountUpdated = Notification.Name("notificationCountUpdated")
}


final class NotificationCountViewModel: BaseViewModel {

    func fetchCount() async throws -> Int {
        let response = try await getAllRequest(
            NotificationsEndPoints.notificationCount()
        )
        return response.data?.notificationCount ?? 0
    }
}
