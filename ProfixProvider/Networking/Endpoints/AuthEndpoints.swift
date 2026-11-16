//
//  AuthEndpoints.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation
import Alamofire

struct AuthEndpoints {
    private init() {}
}

extension AuthEndpoints {
    
    static func introRequest() -> Endpoint<BaseResponse<IntroResponse>>{
        return .init(
            method: .get,
            path: "intro"
        )
    }
    
    static func login(model : LoginModel) -> Endpoint<BaseResponse<LoginResponse>>{
        return .init(
            method: .post,
            path: "login",
            body: [
                "phone": model.phone,
                "password": model.password,
                "device_id": UserDefaults.pushNotificationToken,
                "device_type": "ios",
                "type": "delegate",
                "country_key" : "00966"
            ]
        )
    }
    
    static func signup(model: SignupModel, uploads: [UploadData]) -> Endpoint<BaseResponse<LoginResponse>>{
        return .init(
            method: .post,
            path: "register-delegate",
            body:[
                "name" : model.name,
                "phone" : model.phone,
                "country_key" : "00966",
                "city_id" : model.cityId,
                "password" : model.password,
                "lat" : model.lat,
                "long" : model.long,
                "address" : model.address,
                "bank_name" : model.bankName,
                "bank_owner_name" : model.bankOwnerName,
                "bank_account_number" : model.bankAccountNumber,
                "bank_iban_number" : model.bankIBANNumber,
                "visit_request_price" : model.visitRequestPrice ,
                "bio" : model.bio,
                "categories_ids" : model.categoriesIds,
                "device_id": UserDefaults.pushNotificationToken,
                "device_type": "ios"
            ],
            uploads: uploads
        )
    }
    
    static func getCities(countryId : Int) -> Endpoint<BaseResponse<CityResponse>>{
        return .init(
            method: .get,
            path: "cities",
            queries: [
                "country_id" : countryId
            ]
        )
    }
    
    static func getCategories() -> Endpoint<BaseResponse<CategoriesResponse>>{
        return .init(
            method: .get,
            path: "categories"
        )
    }
    
    static func verification(code: String , token : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "account/activation/delegate",
            body: [
                "code": code
            ],
            headerType: .authorized(token: token)
        )
    }
    
    static func resendCode(token : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "code/resend",
            headerType: .authorized(token: token)
        )
    }
    
    static func forgetPassword(phone: String) -> Endpoint<BaseResponse<LoginResponse>> {
        return .init(
            method: .post,
            path: "password/forget",
            body: [
                "phone": phone,
                "country_key": "00966"
            ]
        )
    }
    
    static func resetPassword(password : String , token : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "password/reset",
            body: [
                "password" : password,
            ],
            headerType: .authorized(token: token)
        )
    }
}
