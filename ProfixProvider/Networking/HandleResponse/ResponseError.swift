//
//  ResponseError.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

enum ResponseError: Error {
    case canNotConnectToServer
    case serverError
    case unableToDecodeResponse
    case server(message: String)
    case unAuthorized
    case blocked
    case exception
    case needActive
}

extension ResponseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .canNotConnectToServer:
            return "Can not send request, please check your connection".localized
        case .serverError:
            return "There is an error in our servers and we work on it, please try again later".localized
        case .unableToDecodeResponse:
            return "unexpected error happened and we will work on it, please try again later".localized
        case .server(let message):
            return message
        case .unAuthorized:
            return "Your session has been expired,Please Login again".localized
        case .blocked:
            return "Your session has been expired,Please Login again".localized
        case .exception:
            return "unexpected error happened and we will work on it, please try again later".localized
        case .needActive:
            return "Your account is not approved by administration".localized
        }
    }
}

