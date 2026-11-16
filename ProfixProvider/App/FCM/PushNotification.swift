//
//  PushNotification.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation
import Firebase
import FirebaseMessaging
import AVFoundation

private final class OrderNotificationSoundPlayer {
    static let shared = OrderNotificationSoundPlayer()

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func play() {
        guard let url = Bundle.main.url(forResource: "order_sound", withExtension: "caf") else {
            assertionFailure("The bundled order notification sound is missing.")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Unable to play the order notification sound: \(error.localizedDescription)")
        }
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "No Device token found")")
        UserDefaults.pushNotificationToken = fcmToken ?? "No Token Found"
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
    
    //MARK: - Handel the arrived Notifications
    
    //Use this method to process incoming remote notifications for your app
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCountManager.shared.refresh()
        
        print(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //when the notification arrives and the app is in foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("Notification info is: \n\(userInfo)")
        
        let targetValue = userInfo[AnyHashable(FCMValueKeys.type.rawValue)] as? String
        let notificationType = NotificationType(rawValue: targetValue ?? "") ?? .unknown
        let isOrderNotification = notificationType.isOrderNotification
        if isOrderNotification {
            OrderNotificationSoundPlayer.shared.play()
        }
        
        switch targetValue {
        case NotificationType.payOrder.rawValue,
            NotificationType.newOrder.rawValue,
            NotificationType.newReview.rawValue,
            NotificationType.userAcceptInvoice.rawValue,
            NotificationType.userCancelOrder.rawValue,
            NotificationType.userRejectInvoice.rawValue,
            NotificationType.userUpdateOrderDate.rawValue,
            NotificationType.orderIsPaid.rawValue:
            NotificationCountManager.shared.refresh()

            let orderId = userInfo[AnyHashable(FCMValueKeys.orderId.rawValue)] as? String
            let dic = [FCMValueKeys.id.rawValue: orderId]
            NotificationCenter.default.post(name: .isOrderChanged, object: nil, userInfo: dic as [AnyHashable: Any])
            
        case NotificationType.blockNotify.rawValue,
            NotificationType.deleteNotify.rawValue:
            blockUser()
            
        default:
            break
        }

        let presentationOptions: UNNotificationPresentationOptions = isOrderNotification
            ? [.banner, .badge]
            : [.banner, .sound, .badge]
        completionHandler(presentationOptions)
    }
    
    // when the user tap on the notification banar
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        guard let targetValue = userInfo[AnyHashable(FCMValueKeys.type.rawValue)] as? String else {
            print("No target type found in notification ❌")
            return }
        
        guard let tabBar = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController as? AppTabBarController else { return }
        
        let notificationType = NotificationType(rawValue: targetValue) ?? .unknown
        let orderId = userInfo[AnyHashable(FCMValueKeys.orderId.rawValue)] as? String
        let roomId = userInfo[AnyHashable(FCMValueKeys.roomId.rawValue)] as? String
        let ticketId = userInfo[AnyHashable(FCMValueKeys.ticketId.rawValue)] as? String

        switch notificationType {
        case  .payOrder ,.newOrder , .userAcceptInvoice, .userCancelOrder , .userRejectInvoice , .userUpdateOrderDate , .scheduledOrderReminder, .orderIsPaid:
            
            NotificationCountManager.shared.refresh()
            guard let orderId = orderId?.toInt()  else { return }
                tabBar.routeToOrder(orderId)
         
        case  .newReview :
            NotificationCountManager.shared.refresh()
            tabBar.routeToMyRatings()
            
        case .newMessage:
            tabBar.routeToChat(roomId?.toInt() ?? 0)
            
        case .ticketReply , .ticketInprogress:
            tabBar.routeToTicket(ticketId?.toInt() ?? 0)
            
        case .settlementNotify:
            tabBar.routeToFinancials()
            
        case .delegateUpdated , .delegateUpdateRequestApproved , .delegateUpdateRequestRejected:
            tabBar.routeToProfile()
            
        case .delegateWorkAccepted , .delegateWorkRejected ,.delegateWorkUpdateRejected ,.delegateWorkUpdateAccepted :
            tabBar.routeToPreviousWork()
            
        case .blockNotify , .deleteNotify :
            blockUser()
        default:
            break
        }
        
        completionHandler()
    }
}

private extension NotificationType {
    var isOrderNotification: Bool {
        switch self {
        case .payOrder,
             .newOrder,
             .userAcceptInvoice,
             .userCancelOrder,
             .userRejectInvoice,
             .userUpdateOrderDate,
             .scheduledOrderReminder,
             .orderIsPaid:
            return true
        default:
            return false
        }
    }
}

// MARK: - Helper Functions -

extension AppDelegate {
    
    private func getCurrentTabBar() -> AppTabBarController? {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let tabBar = window?.rootViewController as? AppTabBarController else { return nil}
        return tabBar
    }
    
    private func currentNavigationRootVC() -> BaseNav? {
        guard let tabBar = getCurrentTabBar() else { return nil }
        return tabBar.viewControllers?.first as? BaseNav
    }
    
    private func goTo(vc: UIViewController) {
        let window = SceneDelegate.current?.window
        var rootVC = window?.rootViewController as? UITabBarController
        
        if rootVC == nil {
            AppHelper.changeWindowRoot(vc: AppTabBarController())
            rootVC = (SceneDelegate.current?.window?.rootViewController as? UITabBarController)
        }
        
        if let selectedIndex = rootVC?.selectedIndex {
            rootVC?.viewControllers?[selectedIndex].show(vc, sender: self)
        }
    }
    
    private func blockUser() {
        Session.isLogin = false
        Session.token = nil
        Session.user = nil
        UserDefaults.notificationCount = 0
        let vc = SplashVC()
        AppHelper.changeWindowRoot(vc: vc, options: .transitionCurlDown)
    }
}
