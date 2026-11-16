//
//  Session.swift
//  Profix
//
//  Created by Haneen on 15/01/2026.
//


import Foundation

struct Session {
    static var token: String? {
        get {
            return UserDefaults.accessToken
        }
        set {
            UserDefaults.accessToken = newValue
        }
    }
    
    static var user: User? {
        get {
            return UserDefaults.user
        }
        set {
            UserDefaults.user = newValue
        }
    }
    
    static var isLogin: Bool? {
        get {
            return UserDefaults.isLogin
        }
        set {
            UserDefaults.isLogin = newValue ?? true
        }
    }
}
