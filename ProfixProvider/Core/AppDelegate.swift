//
//  AppDelegate.swift
//  ProfixProvider
//
//  Created by Haneen on 26/01/2026.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import FirebaseCore
import FirebaseMessaging
import Clarity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Properties -
    
    static var isRunningTests: Bool {
        NSClassFromString("XCTestCase") != nil
    }

    let gcmMessageIDKey = "gcm.message_id"
    let googleMapKey = UserDefaults.googleMapKey
    
    //MARK: - Initializer -
    
    override init() {
        super.init()
        if !Self.isRunningTests {
            UIFont.overrideInitialize()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Unit tests use injected services and must not initialize live SDK sessions.
        guard !Self.isRunningTests else { return true }
        
        self.handleKeyboard()
        
        self.handleGoogleMap()
        
        self.handleFCMFor(application)

        AppAnalytics.shared.configure()

        let clarityConfig = ClarityConfig(projectId: "ywin1s1s3s")
        #if DEBUG
        clarityConfig.logLevel = .verbose
        let didInitializeClarity = ClaritySDK.initialize(config: clarityConfig)
        print("[Clarity] Initialization accepted: \(didInitializeClarity)")
        #else
        ClaritySDK.initialize(config: clarityConfig)
        #endif
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    //MARK: - Google Maps -
    
    private func handleGoogleMap() {
        GMSServices.provideAPIKey("AIzaSyA73NKdDrPFoB-f3THMuoYBoPknWEYi8ho")
    }
    
    //MARK: - Keyboard -
    
    private func handleKeyboard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.toolbarConfiguration.tintColor = UIColor(resource: .main)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatVC.self]
        IQKeyboardToolbarManager.shared.disabledToolbarClasses = [ChatVC.self]
        //KeyboardStateManager.shared.start()
    }
    
    
//    //MARK: - FCM -
    private func handleFCMFor(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
}
