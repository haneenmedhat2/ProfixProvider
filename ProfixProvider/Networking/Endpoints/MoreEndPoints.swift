//
//  MoreEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 21/08/2025.
//

import Foundation
import Alamofire

struct MoreEndpoints {
    private init() {}
}

extension MoreEndpoints {
    
    static func profile() -> Endpoint<BaseResponse<ProfileResponseModel>>{
        return .init(
            method: .get,
            path: "profile/show",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func updateProfile(model:UpdateProfileModel, uploads: [UploadData]) -> Endpoint<BaseResponse<ProfileResponseModel>>{
        return .init(
            method: .post,
            path: "profile/update/delegate",
            body: [
                "name": model.name,
                "categories_ids" : model.categoryIds?.json(),
                "city_id": model.cityId,
                "lat" : model.lat,
                "long" : model.long,
                "address" : model.address,
                "bio" : model.bio,
                "bank_name" : model.bankName,
                "bank_owner_name" : model.bankOwnerName,
                "bank_account_number" : model.bankAccountNumber,
                "bank_iban_number" : model.bankIbanNumber,
                "visit_request_price" : model.visitRequestPrice
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: uploads
        )
    }
    
    static func addNewWork(model:AddNewWorkModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "add-work",
            body: ["category_id": model.categoryId],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData
        )
    }
    
    static func checkPassword(password: String) -> Endpoint<BaseResponse<CurrentPasswordResponse>>{
        return .init(
            method: .post,
            path: "check-password",
            body: [
                "password" : password
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func newPhone(phone : String) -> Endpoint<BaseResponse<LoginResponse>>{
        return .init(
            method: .post,
            path: "new-phone",
            body: [
                "phone": phone,
                "country_key" : "00966"
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func newPhoneActivation(code:String) -> Endpoint<BaseResponse<LoginResponse>>{
        return .init(
            method: .post,
            path: "new-phone-active",
            body: [
                "code": code
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func resendNewPhoneCode(phone:String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "code/resend-new",
            body: [
                "phone" : phone,
                "country_key" : "00966"
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func changePassword(model:ChangePasswordModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "change-password",
            body: [
                "old_password": model.currentPassword,
                "new_password" : model.password
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func switchNotification() -> Endpoint<BaseResponse<SwitchNotification>>{
        return .init(
            method: .patch,
            path: "switch-notification",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func changeLanguage() -> Endpoint<BaseResponse<LoginResponse>>{
        return .init(
            method: .patch,
            path: "change-lang",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteAccount() -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "profile/delete",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getWorks() -> Endpoint<BaseResponse<WorksResponse>>{
        return .init(
            method: .get,
            path: "works",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getWorkDetails(id : Int) -> Endpoint<BaseResponse<WorkDetailsResponse>>{
        return .init(
            method: .get,
            path: "work",
            queries: [
                "work_id" : id
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteWork(id : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .delete,
            path: "delete-work",
            queries: [
                "work_id" : id
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func updateWork(model: UpdateWorkModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "update-work",
            body: [
                "work_id" : model.workId
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData
        )
    }
    
    static func getReviews() -> Endpoint<BaseResponse<ReviewsResponse>>{
        return .init(
            method: .get,
            path: "user-reviews",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func aboutUs() -> Endpoint<BaseResponse<AboutUsResponse>>{
        return .init(
            method: .get,
            path: "about-us"
        )
    }
    
    static func termsAndConditions() -> Endpoint<BaseResponse<TermsResponse>>{
        return .init(
            method: .get,
            path: "terms"
        )
    }
    
    static func privacyPolicy() -> Endpoint<BaseResponse<PrivacyPolicyResponse>>{
        return .init(
            method: .get,
            path: "policy"
        )
    }
    
    static func termsOfUse() -> Endpoint<BaseResponse<TermsOfUseResponse>>{
        return .init(
            method: .get,
            path: "terms-of-use"
        )
    }
    
    static func getComplaints(status: String ) -> Endpoint<BaseResponse<ComplaintsResponse>>{
        return .init(
            method: .get,
            path: "get-tickets",
            queries: [
                "status" : status
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func complaintDetails(id:Int) -> Endpoint<BaseResponse<ComplaintsDetailsResponse>>{
        return .init(
            method: .get,
            path: "single-ticket",
            queries: [
                "ticket_id" : id
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func addNewComplaint(model: AddComplaintsModel) -> Endpoint<BaseResponse<AddComplaintsResponse>>{
        return .init(
            method: .post,
            path: "create-ticket",
            body: [
                "subject": model.subject,
                "text" : model.text
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData
        )
    }
    
    static func contactUs(model: ContactUsModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "contact-us",
            body: [
                "message" : model.message
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func sitePhone() -> Endpoint<BaseResponse<SitePhoneResponse>>{
        return .init(
            method: .get,
            path: "site-phone"
        )
    }

    static func signout() -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "logout",
            body: [
                "device_id": UserDefaults.pushNotificationToken
            ],
            headerType: .authorized(token: Session.token ?? "" )
        )
    }
    
    //MARK: - Financials -
    
    static func getWaitingSettlementsOrders() -> Endpoint<BaseResponse<FinancialDueModel>>{
        return .init(
            method: .get,
            path: "waiting-settlements-orders",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func settlementRequest(model : Settlement) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "settlement-request",
            body: [
                "total_price": model.totalPrice,
                "total_added_value" : model.totalAddedValue,
                "total_app_percentage" : model.totalAppPercentage,
                "total_due" : model.totalDue
            ],
            headerType: .authorized(token: Session.token ?? "" )
        )
    }
    
    static func getNewSettlements() -> Endpoint<BaseResponse<[FinancialTransModel]>>{
        return .init(
            method: .get,
            path: "new-settlements",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getFinishedSettlements() -> Endpoint<BaseResponse<[FinancialTransModel]>>{
        return .init(
            method: .get,
            path: "finished-settlements",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getFinancialDetails(settlementId : Int) -> Endpoint<BaseResponse<FinancialDetailsResponse>>{
        return .init(
            method: .get,
            path: "settlement-details",
            queries: [
                "settlement_id" : settlementId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
