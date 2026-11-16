//
//  SignupModel.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

//MARK: - SignupModel -

struct SignupModel : Codable {
    var name : String?
    var phone : String?
    var countryKey : String?
    var cityId : Int?
    var password : String?
    var confrimPassword : String?
    var lat : Double?
    var long : Double?
    var address : String?
    var bankName : String?
    var bankOwnerName : String?
    var bankAccountNumber : String?
    var bankIBANNumber : String?
    var visitRequestPrice : String?
    var commercialFile : Data? = nil
    var commercialFileName : String? = nil
    var bio : String?
    var categoriesIds : [Int]?
    var avatar : Data? = nil

    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let avatarData = avatar {
            files.append(UploadData(
                key: "avatar",
                data: avatarData,
                mimeType: .jpeg,
                fileName: "\(Date().timeIntervalSince1970).jpeg"
            ))
        }
        if let commercialFile = commercialFile {
            files.append(UploadData(
                key: "commercial_file",
                data: commercialFile,
                mimeType: .pdf,
                fileName: (commercialFileName as NSString?)?.deletingPathExtension ?? "commercial_\(Date().timeIntervalSince1970)"
            ))
        }
        return files
    }
}

//MARK: - City Model -
struct CityResponse : Codable {
    let cities : [CityModel]?
}

struct CityModel : Codable {
    let id : Int?
    let name : String?
}

extension CityModel : SelectionModelPicker {
    var pickerId: Int { id  ?? 0 }
    var pickerName: String { name ?? "" }
}

//MARK: - Categories Model -
struct CategoriesResponse : Codable {
    let categories : [Categories]?
}

struct Categories : Codable {
    let id : Int?
    let name : String?
    let slug : String?
    let image : String?
    let status : String?
}

extension Categories : SelectionModelPicker {
    var pickerId: Int { id  ?? 0 }
    var pickerName: String { name ?? "" }
}

// MARK: - LoginResponse -

struct LoginResponse: Codable {
    let token: String?
    let user: User
}

// MARK: - User -

struct User: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let countryKey: String?
    let phone: String?
    let changedPhone: String?
    let avatar: String?
    let lat: String?
    let long: String?
    let address: String?
    let rate: String?
    let approve: AproveStatus?
    let wallet: String?
    let totalBills: String?
    let totalDeliveryFees: String?
    let numOrders: String?
    let numComments: String?
    let accType: String?
    let newOrdersNotify: Bool?
    let offersNotify: Bool?
    let timeZone: String?
    let lang: String?
    let isNotify: Bool?
    let date: String?
    let cityName : String?
    let cityId : Int?
    let completedInfo : Bool?
    let bankAccountNumber : String?
    let bankIbanNumber : String?
    let bankName : String?
    let bankOwnerName : String?
    let bio : String?
    let categories : [Categories]?
    let visitRequestPrice : String?
    let commercialFile : String?
    let availableForOrders : Bool?
    let changedCountryKey : String?
    let countryFlag : String?
    let countryId : Int?
    let delegateOrdersSuspended : Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, avatar, lat, long, address, rate, approve, wallet, date
        case countryKey = "country_key"
        case changedPhone = "changed_phone"
        case totalBills = "total_bills"
        case totalDeliveryFees = "total_delivery_fees"
        case numOrders = "num_orders"
        case numComments = "num_comments"
        case accType = "acc_type"
        case newOrdersNotify = "new_orders_notify"
        case offersNotify = "offers_notify"
        case timeZone = "time_zone"
        case lang
        case isNotify = "is_notify"
        case cityName = "city_name"
        case cityId = "city_id"
        case completedInfo = "completed_info"
        case bankAccountNumber = "bank_account_number"
        case bankIbanNumber = "bank_iban_number"
        case bankName = "bank_name"
        case bankOwnerName = "bank_owner_name"
        case visitRequestPrice = "visit_request_price"
        case commercialFile = "commercial_file"
        case availableForOrders = "available_for_orders"
        case changedCountryKey = "changed_country_key"
        case countryFlag = "country_flag"
        case countryId = "country_id"
        case delegateOrdersSuspended = "delegate_orders_suspended"
        case bio,categories
    }
}

enum AproveStatus : String , Codable{
    case accept
    case pending
}
