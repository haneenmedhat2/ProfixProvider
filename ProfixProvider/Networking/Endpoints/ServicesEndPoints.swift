//
//  ServicesEndPoints.swift
//  ProfixProvider
//
//  Created by Haneen on 08/02/2026.
//


import Foundation
import Alamofire

struct ServicesEndPoints {
    private init() {}
}

extension ServicesEndPoints {
    
    static func getServices() -> Endpoint<BaseResponse<ServicesResponse>>{
        return .init(
            method: .get,
            path: "services",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getCategories() -> Endpoint<BaseResponse<CategoriesResponse>>{
        return .init(
            method: .get,
            path: "delegate-categories",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func addNewService(model : AddNewServiceModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "add-service",
            body: [
                "category_id" : model.categoryId,
                "subcategory_id" : model.subcategoryId,
                "price" : model.price,
                "description" : model.decription
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getSubcategories(categoryId : Int)
    -> Endpoint<BaseResponse<SubCategoryResponse>> {
        
        return .init(
            method: .get,
            path: "subcategories",
            queries: [
                "category_id": categoryId
            ]
        )
    }
    
    static func getServiceDetails(serviceId : Int)
    -> Endpoint<BaseResponse<ServiceDetailsResponse>> {
        return .init(
            method: .get,
            path: "service",
            queries: [
                "service_id": serviceId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func updateService(model : AddNewServiceModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "update-service",
            body: [
                "service_id" : model.serviceId,
                "category_id" : model.categoryId,
                "subcategory_id" : model.subcategoryId,
                "price" : model.price,
                "description" : model.decription
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteService(serviceId : Int)
    -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .delete,
            path: "delete-service",
            queries: [
                "service_id": serviceId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
