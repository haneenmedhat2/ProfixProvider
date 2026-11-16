//
//  ValidationError.swift
//
//  Created by MGAbouarab®
//

import Foundation

enum ValidationError: Error {
    
    //MARK: - Name -
    case emptyFirstName
    case shortFirstName
    case longFirstName
    case emptyLastName
    case shortLastName
    case longLastName
    case emptyFamilyName
    case shortFamilyName
    case longFamilyName
    case emptyFullName
    case shortFullName
    case longFullName
    case emptyName
    case shortName
    case longName
    case emptyUsername
    case emptyProviderName
    case shortProviderName
    case longProviderName
    
    //MARK: - Phone -
    case emptyPhoneNumber
    case incorrectPhoneNumber
    case incorrectWhatsAppNumber
    case emptyNewPhone
    //MARK: - Verification Code -
    case emptyVerificationCode
    case incorrectVerificationCode
    
    //MARK: - Email -
    case emptyMail
    case wrongMail
    
    //MARK: - Passwords -
    case emptyPassword
    case shortPassword
    case emptyNewPassword
    case shortNewPassword
    case emptyOldPassword
    case shortOldPassword
    case emptyConfirmNewPassword
    case emptyConfirmPassword
    case notMatchPasswords
    case terms
    case emptyCurrentPassword
    
    //MARK: - Locations -
    case emptyCountry
    case emptyGovernorate
    case emptyCity
    case floorNumbers
    case emptyArea
    case emptyStreet
    case addressType
    case emptyLocation
    case estateLocation
    case emptyAddressDetails
    
    //MARK: - Images -
    case coverPicture
    case profilePicture
    case licensePicture
    case productPicture
    case contractNumber
    
    //MARK: - carPlate -
    case carPicture
    case carPlate
    case carModel
    case carType
    
    //MARK: - Date -
    case emptyAge
    case youngAge
    case emptyDate
    case notOldDate
    case notNewDate
    case emptyTime
    //MARK: - Message -
    case emptyTitle
    case emptyMessage
    case emptySubject
    case emptyTitleType
    case emptyContactReason
    //MARK: - Bank -
    case bankAccountHolder
    case bankName
    case bankTransferImage
    case fromBankName
    case bankAccountNumber
    case invalidSaudiIBAN
    case invalidSaudiBankAccountNumber
    
    //MARK: - category -
    case emptyCategory
    case emptyPriceBefore
    case emptyPriceAfter
    case priceBeforeSmallThanPriceAfter
    case emptyDescription
    case iban
    
    //MARK: - Terms and condition -
    case uncheckedTerms
    
    //MARK: - Restart -
    case restartApp
    
    //MARK: - OTP Verification -
    case emptyOTP
    case incorrectOTP
    
    //MARK: - Empty Fields -
    case unSelectedItem
    case unSelectedService
    case emptyAddressTitle
    case emptyAddressDescription
    case emptyProductType
    case emptySpecifications
    case emptyRequiredQuantity
    case emptyPaymentMethod
    case unselectedCancelReason
    case unselectedInvoiceRejectionReason
    case unselectedPaymentMethod
    case noSelectedImage
    case unselectedLanguage
    //MARK: - Wallet -
    case emptyAmount
    case invalidAmount
    
    //MARK: - Gender -
    case unselectedGender
    
    //MARK: - Complaint -
    case emptyComplaintTitle
    case emptyComplaintDetails
    case emptyComplaintReason
    
    //MARK: - Notes -
    case emptyNotes
    
    //MARK: - Empty Reason -
    case emptyReason
    
    //MARK: - Rating -
    case emptyRatingStars
    case emptyRatingcomment

    case emptyExecutionDate
    case emptyExecutionTime
    case emptyExecutionLocation
    case emptyProblemDetails
    
    //MARK: - Service-
    case emptyServicePrice
    case invalidServicePrice
    case servicePriceBelowMinimum
    case emptyServiceDesc
    case shortServiceDescription
    case emptyServiceName
    case shortServiceName
    case securityCode

    //MARK: - Visit Price -
    case emptyVisitPrice
    case invalidVisitPrice
    case visitPriceBelowMinimum

    //MARK: - Commercial Registration -
    case emptyCommercialRegistrationNumber
    case emptyCommercialFile
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        
        switch self {
            //MARK: - Name -
        case .emptyFirstName:
            return "Please enter first name.".validationLocalized
        case .shortFirstName:
            return "First name is too short.".validationLocalized
        case .longFirstName:
            return "First name is too long.".validationLocalized
        case .emptyLastName:
            return "Please enter last name.".validationLocalized
        case .shortLastName:
            return "Last name is too short.".validationLocalized
        case .longLastName:
            return "Last name is too long.".validationLocalized
        case .emptyFamilyName:
            return "Please enter family name.".validationLocalized
        case .shortFamilyName:
            return "Family name is too short.".validationLocalized
        case .longFamilyName:
            return "Family name is too long.".validationLocalized
        case .emptyFullName:
            return "Please enter full name.".validationLocalized
        case .shortFullName:
            return "Full name is too short.".validationLocalized
        case .longFullName:
            return "Full name is too long.".validationLocalized
        case .emptyName:
            return "Please enter name.".validationLocalized
        case .shortName:
            return "Name is too short.".validationLocalized
        case .longName:
            return "Name is too long.".validationLocalized
        case .emptyUsername:
            return "please_enter_username".validationLocalized
        case .emptyProviderName:
            return "provider_name_empty".validationLocalized

        case .shortProviderName:
            return "provider_name_too_short".validationLocalized

        case .longProviderName:
            return "provider_name_too_long".validationLocalized

            
            //MARK: - Phone -
        case .emptyPhoneNumber:
            return "Please enter your phone number.".validationLocalized
        case .incorrectPhoneNumber:
            return "invalid_saudi_phone".validationLocalized
        case .incorrectWhatsAppNumber:
            return "Please enter correct whatsApp number.".validationLocalized
        case .emptyNewPhone:
            return "enter_new_phone_number".validationLocalized
            
            //MARK: - Verification Code -
        case .emptyVerificationCode:
            return "Please enter verification code".validationLocalized
        case .incorrectVerificationCode:
            return "Verification Code should be 4 digits.".validationLocalized
        case .estateLocation:
            return "Please enter estate location".validationLocalized
        case .contractNumber:
            return "Please enter contract number".validationLocalized
            //MARK: - Email -
        case .emptyMail:
            return "Please enter email field.".validationLocalized
        case .wrongMail:
            return "Please enter correct email address.".validationLocalized
            
            //MARK: - Passwords -
        case .emptyPassword:
            return "Please enter password field.".validationLocalized
        case .shortPassword:
            return "Password is too short, it should be 8 characters at least.".validationLocalized
        case .emptyNewPassword:
            return "Please enter new password field.".validationLocalized
        case .shortNewPassword:
            return "New password is too short, it should be 8 characters at least.".validationLocalized
        case .emptyOldPassword:
            return "Please enter old password field.".validationLocalized
        case .shortOldPassword:
            return "Old password is too short, it should be 8 characters at least.".validationLocalized
        case .emptyConfirmNewPassword:
            return "Please enter confirm new password field.".validationLocalized
        case .emptyConfirmPassword:
            return "Please enter confirm password field.".validationLocalized
        case .notMatchPasswords:
            return "passwords_do_not_match".validationLocalized
        case .terms:
            return "Please read and agree our terms and conditions first".validationLocalized
        case .emptyCurrentPassword:
            return "empty_current_password".validationLocalized
            //MARK: - Locations -
        case .emptyCountry:
            return "Please select country.".validationLocalized
        case .emptyGovernorate:
            return "Please select governorate".validationLocalized
        case .emptyCity:
            return "Please select city.".validationLocalized
        case .floorNumbers:
            return "Please select the floor".validationLocalized
        case .emptyArea:
            return "Please select area.".validationLocalized
        case .emptyStreet:
            return "Please enter street name.".validationLocalized
        case .addressType:
            return "Please enter address type.".validationLocalized
        case .emptyLocation:
            return "Please select the location.".validationLocalized
        case .emptyAddressDetails:
            return "Please write address details".validationLocalized
            
            //MARK: - Images -
        case .coverPicture:
            return "Please pick cover picture.".validationLocalized
        case .profilePicture:
            return "Please pick your profile picture.".validationLocalized
        case .licensePicture:
            return "Please pick license picture.".validationLocalized
        case .productPicture:
            return "Please pick product image.".validationLocalized
            
            //MARK: - Cars -
        case .carPicture:
            return "Please pick car picture".validationLocalized
        case .carPlate:
            return "Please enter car plate number.".validationLocalized
        case .carModel:
            return "Please select car model.".validationLocalized
        case .carType:
            return "Please Select car type.".validationLocalized
            
            //MARK: - Date -
        case .emptyAge:
            return "Please enter the age.".validationLocalized
        case .youngAge:
            return "If it is your age, please grow up first =D.".validationLocalized
        case .notOldDate:
            return "Please select older date.".validationLocalized
        case .notNewDate:
            return "Please select newer date.".validationLocalized
        case .emptyDate:
            return "Please choose a time to continue".validationLocalized
            
        case .emptyTime:
            return "Please select the time.".validationLocalized
            
            //MARK: - Message -
        case .emptyTitle:
            return "Please enter message title".validationLocalized
        case .emptyMessage:
            return "Please enter your message".validationLocalized
        case .emptySubject:
            return "Please enter message subject".validationLocalized
        case .emptyTitleType:
            return "Please enter title type".validationLocalized
        case .emptyContactReason:
            return "Please choose contact reason".validationLocalized
            
            //MARK: - Bank -
        case .bankAccountHolder:
            return "Please enter bank account holder name".validationLocalized
        case .bankName:
            return "Please enter bank name".validationLocalized
        case .bankTransferImage:
            return "Please select bank transfer image".validationLocalized
        case .fromBankName:
            return "Please enter from bank name".validationLocalized
        case .bankAccountNumber:
            return "Please enter bank account number".validationLocalized
        case .iban:
            return "Please enter IBAN number".validationLocalized
        case .invalidSaudiIBAN:
            return "invalid_saudi_iban".validationLocalized
        case .invalidSaudiBankAccountNumber:
            return "invalid_saudi_bank_account_number".validationLocalized
            
            //MARK: - category -
        case .emptyCategory:
            return "main_category_required".validationLocalized
        case .emptyPriceBefore:
            return "Please enter price before".validationLocalized
        case .emptyPriceAfter:
            return "Please enter price after".validationLocalized
        case .priceBeforeSmallThanPriceAfter:
            return "price before is smaller than price after".validationLocalized
        case .emptyDescription:
            return "Please enter description".validationLocalized
            
            
            //MARK: - Terms and condition -
        case .uncheckedTerms:
            return "Please accept terms and conditions to continue.".localized
            
            //MARK: - Restart -
        case .restartApp:
            return "Please restart the app to apply language changes.".localized
            
            //MARK: - OTP Verification -
        case .emptyOTP:
            return "Please enter OTP number to continue.".localized
        case .incorrectOTP:
            return "OTP verification failed. Please Try again.".localized
            
            
            //MARK: - Empty Fields -
        case .unSelectedItem:
            return "Please choose to continue.".localized
            
        case .emptyAddressTitle:
            return "Please enter address title".localized
        case .emptyAddressDescription:
            return "Please enter address description".localized
            
        case .unSelectedService:
            return "Please select a service.".validationLocalized
            
        case .emptyProductType:
            return "empty_product_type".validationLocalized

        case .emptySpecifications:
            return "empty_product_specifications".validationLocalized

        case .emptyRequiredQuantity:
            return "empty_required_quantity".validationLocalized
            
        case .emptyPaymentMethod:
            return "empty_payment_method".validationLocalized
            
        case .unselectedCancelReason:
            return "cancel_order_reason_required".validationLocalized

        case .unselectedInvoiceRejectionReason:
            return "reject_invoice_reason_required".validationLocalized
            
        case .unselectedPaymentMethod:
            return "payment_method_required".validationLocalized
            
        case .noSelectedImage:
            return "selected_image_validation".validationLocalized
            
        case .unselectedLanguage:
            return "Please choose language to continue ".validationLocalized

            //MARK: - Wallet -
            
        case .emptyAmount:
            return "emptyAmount".validationLocalized
            
        case .invalidAmount:
            return "invalidAmount".validationLocalized
            
            //MARK: - Gender -
        case .unselectedGender:
            return "Please select a gender".validationLocalized
            
            //MARK: - Complaint -
        case .emptyComplaintTitle:
            return "Please enter complaint title".validationLocalized
            
        case .emptyComplaintDetails:
            return "Please enter complaint details".validationLocalized
        
        case .emptyComplaintReason:
            return "enter_complaint_reason".validationLocalized
            
            //MARK: - Notes -
        case .emptyNotes:
            return "Please enter your notes to continue".validationLocalized
            
            //MARK: - Empty Reason -
        case .emptyReason:
            return "Please enter reason to continue".validationLocalized
            
            //MARK: -  Rating -
        case .emptyRatingStars:
            return "empty_rating_stars".validationLocalized
        case .emptyRatingcomment:
            return "empty_rating_comment".validationLocalized
            
            
        case .emptyExecutionDate:
                   return "validation.execution_date".validationLocalized
               case .emptyExecutionTime:
                   return "validation.execution_time".validationLocalized
               case .emptyExecutionLocation:
                   return "validation.execution_location".validationLocalized
               case .emptyProblemDetails:
                   return "validation.complaint_desc".validationLocalized
            
            //MARK: -  Service -

        case .emptyServicePrice:
            return "empty_service_price".validationLocalized
            
        case .invalidServicePrice:
            return "invalid_service_price".validationLocalized

        case .servicePriceBelowMinimum:
            return "service_price_minimum".validationLocalized

        case .emptyServiceDesc:
            return "empty_service_description".validationLocalized
            
        case .shortServiceDescription:
            return "short_service_description".validationLocalized
    
        case .emptyServiceName:
            return "service_name_required".validationLocalized

        case .shortServiceName:
            return "service_name_min_length".validationLocalized
            
        case .securityCode:
            return "enter_security_code_to_confirm".validationLocalized

            //MARK: - Visit Price -
        case .emptyVisitPrice:
            return "empty_visit_price".validationLocalized
        case .invalidVisitPrice:
            return "invalid_visit_price".validationLocalized

        case .visitPriceBelowMinimum:
            return "visit_price_minimum".validationLocalized

            //MARK: - Commercial Registration -
        case .emptyCommercialRegistrationNumber:
            return "empty_commercial_registration_number".validationLocalized
        case .emptyCommercialFile:
            return "empty_commercial_file".validationLocalized
        }
    }
}
