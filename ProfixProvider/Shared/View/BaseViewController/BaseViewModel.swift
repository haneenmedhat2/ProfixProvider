//
//  BaseViewModel.swift
// NewBase
//
//  Created by Mohamed Hadwa on 04/01/2024.
//

import Foundation
import Combine
import UIKit


class BaseViewModel: NSObject, ObservableObject {
    
    private(set) var isGotNotificationsCount: PassthroughSubject<Int,Never> = .init()
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var isUnauthenticated: Bool = false
    var unAuthenticated = PassthroughSubject<Bool,Never>()
    var showMessage = PassthroughSubject<String,Never>()
    var isBlocked = PassthroughSubject<String,Never>()
    
//    @Published private(set) var remainingTime:String = ""
//    @Published private(set) var isTimerActive:Bool = false
//    
    //MARK: -properties-
    var countdownTime: Int = 120
  //  var timer: AnyCancellable?
    var token: String = UserDefaults.accessToken ?? ""
    let deviceID = UserDefaults.pushNotificationToken ?? ""
    let macAddress = UIDevice.current.identifierForVendor!.uuidString
    let networkService = NetworkService()
    
    let responseHandler: ResponseHandler
    
    init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        self.responseHandler = responseHandler
    }
    
    func getAllRequest<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> BaseResponse<ResponseData> {
        let response = try await self.responseHandler.get(endPoint, progress: progress)
        
        switch response.key {
            
        case .exception:
            throw ResponseError.server(message: "Something went error, try later ......".localized)
        case .fail:
            showMessage.send(response.message)
            throw ResponseError.server(message: response.message)
        case .unauthenticated:
            //  await blockUser()
            unAuthenticated.send(true)
            await blockUser()
            throw ResponseError.server(message: response.message)
        case .blocked:
            //isBlocked.send(response.message)
            await blockUser()
            throw ResponseError.server(message: response.message)
            
        case .needActive:
            if Session.isLogin ?? true {
                await blockUser()
                throw ResponseError.server(message: response.message)
            } else {
                return response
            }
            
        case .success:
            return response
            
        default:
            return response
        }
    }
    
    func request<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> ResponseData? {
        let response = try await self.responseHandler.get(endPoint, progress: progress)
        switch response.key {
        case .exception:
            throw ResponseError.server(message: "Something went error, try later ......".localized)
        case .fail:
            showMessage.send(response.message)
            throw ResponseError.server(message: response.message)
        case .unauthenticated:
            unAuthenticated.send(true)
            await blockUser()
            throw ResponseError.server(message: response.message)
        case .blocked:
            await blockUser()
            throw ResponseError.server(message: response.message)
            
        case .needActive:
            
            await blockUser()
            throw ResponseError.server(message: response.message)
            
            
        default:
            return response.data
        }
    }
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "BaseViewModel") is deinit, No memory leak found")
    }
    
    @MainActor private func blockUser() {
        Session.isLogin = false
        Session.token  = nil
        Session.user = nil
        let vc = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
}

extension BaseViewModel{
    func getUserNotificationsCount() {
        //        self.isLoading = true
        //        Task {
        //            let endpoint = ClientHomeEndpoints.getNotificationCount(token: self.token)
        //            do {
        //                let response = try await networkService.request(endpoint, progress: nil)
        //                guard let number = response?.count else {return}
        //                self.isGotNotificationsCount.send(number)
        //                UserDefaults.notificationCount = number
        //                //self.isLoading = false
        //            } catch {
        //                //self.isLoading = false
        //                self.error = error
        //            }
        //        }
    }
    
    func getNotificationsCount(){
        getUserNotificationsCount()
    }
    
}
