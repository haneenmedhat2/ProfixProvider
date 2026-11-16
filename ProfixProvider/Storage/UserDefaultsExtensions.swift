//
//  UserDefaultsExtensions.swift
//  Waraqa
//
//  Created by Haneen on 03/08/2025.
//

import Foundation

@propertyWrapper
struct ValueDefault<Value> {
    
    let key: String
    let defaultValue: Value
    let container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.value(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.setValue(newValue, forKey: key)
        }
    }
}
@propertyWrapper
struct ModelsDefault<Model: Codable> {
    
    let key: String
    let defaultValue: Model
    let container: UserDefaults = .standard
    
    var wrappedValue: Model {
        get {
            let decoder = JSONDecoder()
            guard let decoded = container.object(forKey: key) as? Data else {return defaultValue}
            let loadedValue = try? decoder.decode(Model.self, from: decoded)
            return loadedValue ?? defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                container.set(encoded, forKey: key)
                container.synchronize()
            }
        }
    }
}

extension UserDefaults {
    
    private enum Keys: String {
        case googleMapKey
        case accessToken
        case pushNotificationToken
        case isFirstTime
        case isLogin
        case notificationCount
        case user
        case currentLocation
        case isNotify
        case languageChanged
    }
    
    
    @ModelsDefault(key: Keys.user.rawValue, defaultValue: nil)
        static var user: User?
    
    @ModelsDefault(key: Keys.currentLocation.rawValue, defaultValue: nil)
        static var currentLocation: AddressModel?
    
    @ValueDefault(key: Keys.googleMapKey.rawValue, defaultValue: String())
    static var googleMapKey: String
    
    @ValueDefault(key: Keys.isLogin.rawValue, defaultValue: false)
    static var isLogin: Bool
    
    @ModelsDefault(key: Keys.accessToken.rawValue, defaultValue: nil)
    static var accessToken: String?
    
    @ValueDefault(key: Keys.pushNotificationToken.rawValue, defaultValue: nil)
    static var pushNotificationToken: String?
    
    @ValueDefault(key: Keys.isFirstTime.rawValue, defaultValue: true)
    static var isFirstTime: Bool
    
    @ValueDefault(key: Keys.notificationCount.rawValue, defaultValue: 0)
    static var notificationCount: Int

    @ValueDefault(key: Keys.isNotify.rawValue, defaultValue: true )
    static var isNotify: Bool
    
    @ValueDefault(key: Keys.languageChanged.rawValue, defaultValue: false )
    static var languageChanged: Bool
}
