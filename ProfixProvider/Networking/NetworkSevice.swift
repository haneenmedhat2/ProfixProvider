//
//  NetworkSevice.swift
//  PickUp
//
//  Created by Abdelrahman on 02/02/2025.
//



import Foundation

protocol NetworkServiceProtocol {
    func request<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int) -> Void)?) async throws -> ResponseData?
    func requestFullResponse<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int) -> Void)?) async throws -> BaseResponse<ResponseData>
}


class NetworkService: NetworkServiceProtocol {
    private let responseHandler: ResponseHandler

    init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        self.responseHandler = responseHandler
    }

    func request<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> ResponseData? {
//        DispatchQueue.main.async {
//            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//            window?.endEditing(true)
//        }
        let response = try await self.responseHandler.get(endPoint, progress: progress)
        switch response.key {
        case .success,.needApproval, .needApprove , .refused:
            return response.data
        case .needActive:
            //return response.data
            throw ResponseError.unAuthorized
        case .fail, .exception:
            throw ResponseError.server(message: response.message)
        case .unauthenticated:
            throw ResponseError.unAuthorized
        case .blocked:
            throw ResponseError.blocked
        }
    }

    func requestFullResponse<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> BaseResponse<ResponseData> {
        
        let response = try await self.responseHandler.get(endPoint, progress: progress)
        switch response.key {
        case .success,.needApproval , .needApprove , .refused:
            return response
        case .needActive:
            //return response
            throw ResponseError.unAuthorized
        case .fail, .exception:
            throw ResponseError.server(message: response.message)
        case .unauthenticated:
            throw ResponseError.unAuthorized
        case .blocked:
            throw ResponseError.server(message: response.message)
        }
    }
}
