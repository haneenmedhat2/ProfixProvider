//
//  ValidationService.swift
//
//  Created by MGAbouarab®
//


import Foundation

struct ValidationService {
    
    //MARK: - Name -
    static func validate(firstName: String?) throws -> String {
        guard let firstName = firstName, !firstName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyFirstName
        }
        guard firstName.count > 2 else {
            throw ValidationError.shortFirstName
        }
        guard firstName.count < 61 else {
            throw ValidationError.longFirstName
        }
        return firstName
    }
    static func validate(lastName: String?) throws -> String {
        guard let lastName = lastName, !lastName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyLastName
        }
        guard lastName.count > 2 else {
            throw ValidationError.shortLastName
        }
        guard lastName.count < 61 else {
            throw ValidationError.longLastName
        }
        return lastName
    }
    static func validate(familyName: String?) throws -> String {
        guard let familyName = familyName, !familyName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyFamilyName
        }
        guard familyName.count > 2 else {
            throw ValidationError.shortFamilyName
        }
        guard familyName.count < 61 else {
            throw ValidationError.longFamilyName
        }
        return familyName
    }
    
    @discardableResult
    static func validate(fullName: String?) throws -> String {
        guard let fullName = fullName, !fullName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyFullName
        }
        guard fullName.count > 2 else {
            throw ValidationError.shortFullName
        }
        guard fullName.count < 61 else {
            throw ValidationError.longFullName
        }
        return fullName
    }
    static func validate(name: String?) throws -> String {

        guard let name = name, !name.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyName
        }
        guard name.count > 1 else {
            throw ValidationError.shortName
        }
        guard name.count < 61 else {
            throw ValidationError.longName
        }
        return name
    }
    
    static func validate(providerName: String?) throws -> String {
        
        guard let providerName = providerName, !providerName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyProviderName
        }
        guard providerName.count > 1 else {
            throw ValidationError.shortProviderName
        }
        guard providerName.count < 61 else {
            throw ValidationError.longProviderName
        }
        return providerName
    }
    
    
    //MARK: - Phone -
    
    static func validate(phone: String?) throws -> String {
        guard let phone = phone?.trimWhiteSpace(), !phone.isEmpty else {
            throw ValidationError.emptyPhoneNumber
        }
        
        guard phone.isValidPhoneNumber(pattern: RegularExpression.saudiArabiaPhone.value) else {
            throw ValidationError.incorrectPhoneNumber
        }
        return phone
    }
    
    static func validate(newPhone: String?) throws -> String  {
        guard let phone = newPhone?.trimWhiteSpace(), !phone.isEmpty else {
            throw ValidationError.emptyNewPhone
        }
        
        guard phone.isValidPhoneNumber(pattern: RegularExpression.saudiArabiaPhone.value) else {
            throw ValidationError.incorrectPhoneNumber
        }
        return phone
    }
    
    //MARK: - Verification code -
    
    static func validate(verificationCode: String?) throws -> String {
        
        guard let code = verificationCode?.trimWhiteSpace(), !code.isEmpty else {
            throw ValidationError.emptyVerificationCode
        }
        
        guard code.count == 4 else {
            throw ValidationError.incorrectVerificationCode
        }
        return code
    }
    
    //MARK: - Email -
    static func validate(email: String?) throws -> String {
        guard let email = email, !email.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyMail
        }
        guard email.isValidEmail() else{
            throw ValidationError.wrongMail
        }
        return email
    }
    
    //MARK: - Passwords -
    
    static func validate(password: String?) throws -> String {
        
        guard let password = password?.trimWhiteSpace(), !password.isEmpty else {
            throw ValidationError.emptyPassword
        }
        
        guard password.count > 7 else {
            throw ValidationError.shortPassword
        }
        
        return password
    }
    
    static func validate(newPassword: String?) throws -> String {
        guard let newPassword = newPassword, !newPassword.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyNewPassword
        }
        guard newPassword.count > 7 else {
            throw ValidationError.shortNewPassword
        }
        return newPassword
    }
    
    static func validate(oldPassword: String?)  throws -> String  {
        guard let oldPassword = oldPassword, !oldPassword.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyOldPassword
        }
        guard oldPassword.count > 7 else {
            throw ValidationError.shortOldPassword
        }
        return oldPassword
    }
    
    static func validate(newPassword: String?,
                         confirmPassword: String?) throws -> String {
        
        guard let newPassword = newPassword?.trimWhiteSpace(),
              !newPassword.isEmpty else {
            throw ValidationError.emptyNewPassword
        }
        
        guard let confirmPassword = confirmPassword?.trimWhiteSpace(),
              !confirmPassword.isEmpty else {
            throw ValidationError.emptyConfirmPassword
        }
        
        guard newPassword == confirmPassword else {
            throw ValidationError.notMatchPasswords
        }
        
        return newPassword
    }
    
    
    static func validate(newPassword: String, confirmPassword: String?) throws -> String {
        guard let confirmPassword = confirmPassword, !confirmPassword.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyConfirmPassword
        }
        guard newPassword == confirmPassword else {
            throw ValidationError.notMatchPasswords
        }
        return newPassword
    }
    
    static func validate(termesAgreed: Bool) throws {
        guard termesAgreed else {
            throw ValidationError.terms
        }
    }
    
    //MARK: - Location -
    static func validate(countryId: Int?) throws -> Int {
        guard let countryId = countryId else {
            throw ValidationError.emptyCountry
        }
        return countryId
    }
    static func validate(governorateId: Int?) throws -> Int {
        guard let governorateId = governorateId else {
            throw ValidationError.emptyGovernorate
        }
        return governorateId
    }
    
    static func validate(cityId: Int?) throws -> Int {
        guard let cityId = cityId else {
            throw ValidationError.emptyCity
        }
        return cityId
    }
    
    
    static func validate(areaId: Int?) throws -> Int {
        guard let areaId = areaId else {
            throw ValidationError.emptyArea
        }
        return areaId
    }
    static func validate(streetName: String?) throws -> String {
        guard let streetName = streetName, !streetName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyStreet
        }
        return streetName
    }
    static func validate(department: String?) throws -> String {
        guard let department = department, !department.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyStreet
        }
        return department
        
    }
    static func validate(addressType: String?) throws -> String {
        guard let addressType = addressType, !addressType.trimWhiteSpace().isEmpty else {
            throw ValidationError.addressType
        }
        return addressType
    }
    
    static func validate(addressDetails: String?) throws -> String {
        guard let addressDetails = addressDetails, !addressDetails.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyAddressDetails
        }
        return addressDetails
    }
    
    static func validateLocation(address: String?, lat: Double?, long: Double?) throws -> (address: String, lat: Double, long: Double) {
        guard let address = address, let lat = lat, let long = long else {
            throw ValidationError.emptyLocation
        }
        return (address, lat, long)
    }
    
    //MARK: - Complaints -
    static func validate(complaintTitle: String?) throws -> String  {
        
        guard let title = complaintTitle, !title.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyComplaintReason
        }
        return title
    }
    
    static func validate(complaintDesc: String?) throws -> String {
        
        guard let desc = complaintDesc, !desc.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyComplaintDetails
        }
        return desc
    }
    
    //MARK: - Images -
    static func validate(profilePicture: Data?) throws -> Data {
        guard let profilePicture = profilePicture else {
            throw ValidationError.profilePicture
        }
        return profilePicture
    }
    static func validate(licensePicture: Data?) throws -> Data {
        guard let licensePicture = licensePicture else {
            throw ValidationError.licensePicture
        }
        return licensePicture
    }
    static func validate(productPicture: Data?) throws -> Data {
        guard let productPicture = productPicture else {
            throw ValidationError.productPicture
        }
        return productPicture
    }
    
    //MARK: - Cars -
    @discardableResult
    static func validate(carPicture: Data?) throws -> Data {
        guard let carPicture = carPicture else {
            throw ValidationError.carPicture
        }
        return carPicture
    }
    @discardableResult
    static func validate(carPlate: String?) throws -> String {
        guard let carPlate = carPlate, !carPlate.trimWhiteSpace().isEmpty else {
            throw ValidationError.carPlate
        }
        return carPlate
    }
    
    @discardableResult
    static func validate(carModel: String?) throws -> String {
        guard let carModel = carModel , !carModel.trimWhiteSpace().isEmpty  else {
            throw ValidationError.carModel
        }
        return carModel
    }
    
    @discardableResult
    static func validate(carType: String?) throws -> String {
        guard let carType = carType, !carType.trimWhiteSpace().isEmpty else {
            throw ValidationError.carType
        }
        return carType
    }
    
    //MARK: - Date -
    static func validate(age: String?) throws -> String {
        guard let age = age, !age.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyAge
        }
        guard age.toInt() > 0 else {
            throw ValidationError.youngAge
        }
        return age
    }
    static func validate(oldDate: String?) throws -> String {
        guard let oldDate = oldDate, let date = oldDate.toDate() else {
            throw ValidationError.emptyDate
        }
        guard date.isBeforeNow() else {
            throw ValidationError.notOldDate
        }
        return oldDate
    }
    static func validate(newDate: String?) throws -> String {
        guard let newDate = newDate, let date = newDate.toDate() else {
            throw ValidationError.emptyDate
        }
        guard date.isBeforeNow() else {
            throw ValidationError.notNewDate
        }
        return newDate
    }
    static func validate(date: String?) throws -> String {
        guard let date = date, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyDate
        }
        return date
    }
    
    //MARK: - Message -
    static func validate(title: String?) throws -> String {
        guard let title = title, !title.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyTitle
        }
        return title
    }
    static func validate(titleType: String?) throws -> String {
        guard let titleType = titleType, !titleType.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyTitleType
        }
        return titleType
    }
    
    static func validate(message: String?) throws -> String {
        guard let message = message, !message.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyMessage
        }
        return message
    }
    //MARK: - Bank -
    @discardableResult
    static func validate(bankAccountHolder: String?) throws -> String {
        guard let bankAccountHolder = bankAccountHolder, !bankAccountHolder.trimWhiteSpace().isEmpty else {
            throw ValidationError.bankAccountHolder
        }
        return bankAccountHolder
    }
    
    @discardableResult
    static func validate(bankName: String?) throws -> String {
        guard let bankName = bankName, !bankName.trimWhiteSpace().isEmpty else {
            throw ValidationError.bankName
        }
        return bankName
    }
    static func validate(fromBankName: String?) throws -> String {
        guard let fromBankName = fromBankName, !fromBankName.trimWhiteSpace().isEmpty else {
            throw ValidationError.fromBankName
        }
        return fromBankName
    }
    
    static func validate(bankAccountNumber: String?) throws -> String {
        guard let accountNumber = bankAccountNumber?.trimWhiteSpace(),
              !accountNumber.isEmpty else {
            throw ValidationError.bankAccountNumber
        }
//
//        let accountRegex = "^\\d{18}$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", accountRegex)
//
//        guard predicate.evaluate(with: accountNumber) else {
//            throw ValidationError.invalidSaudiBankAccountNumber
//        }

        return accountNumber
    }

    
    static func validate(iban: String?) throws -> String {
        
        guard let iban = iban?.trimWhiteSpace(),
              !iban.isEmpty else {
            throw ValidationError.iban
        }

        let saudiIbanRegex = "^SA\\d{22}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", saudiIbanRegex)

        guard predicate.evaluate(with: iban) else {
            throw ValidationError.invalidSaudiIBAN
        }

        return iban
    }
    
    static func validate(bankTransferImage: Data?) throws -> Data {
        guard let bankTransferImage = bankTransferImage else {
            throw ValidationError.bankTransferImage
        }
        return bankTransferImage
    }
    
    //MARK: - Categories -
    static func validate(categoryId: Int?) throws -> Int {
        guard let categoryId = categoryId else {
            throw ValidationError.emptyCategory
        }
        return categoryId
        
    }

    static func validate(serviceID: Int?) throws -> Int {
        guard let serviceID = serviceID else {
            throw ValidationError.unSelectedService
        }
        return serviceID
        
    }

    static func validate(priceBefore: String?, priceAfter: String?) throws -> (priceBefore: String, priceAfter: String) {
        guard let priceBefore = priceBefore, !priceBefore.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyPriceBefore
        }
        guard let priceAfter = priceAfter, !priceAfter.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyPriceAfter
        }
        guard priceBefore.toDouble() > priceAfter.toDouble() else {
            throw ValidationError.priceBeforeSmallThanPriceAfter
        }
        return (priceBefore, priceAfter)
        
    }
    
    static func validate(description: String?) throws -> String {
        guard let description = description, !description.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyDescription
        }
        return description
    }
    
    static func validate(image: Data?) throws -> Data {
        guard let image = image else {
            throw ValidationError.noSelectedImage
        }
        return image
    }

    
    //MARK: - Wallet -
    
    static func validateWalletRecharge(amount: String?)  throws -> Double {
        
        guard var amount = amount?.trimWhiteSpace(), !amount.isEmpty else {
            throw ValidationError.emptyAmount
        }
        
        let arabicNumbers = ["٠":"0","١":"1","٢":"2","٣":"3","٤":"4","٥":"5","٦":"6","٧":"7","٨":"8","٩":"9"]
        arabicNumbers.forEach { amount = amount.replacingOccurrences(of: $0.key, with: $0.value) }
        
        amount = amount.replacingOccurrences(of: " ", with: "")
        
        let allowed = CharacterSet(charactersIn: "0123456789.,")
        amount = String(amount.unicodeScalars.filter { allowed.contains($0) })
        
        if amount.filter({ $0 == "." }).count > 1 {
            amount = amount.replacingOccurrences(of: ".", with: "")
        }
        if amount.filter({ $0 == "," }).count > 1 {
            amount = amount.replacingOccurrences(of: ",", with: "")
        }
        
        amount = amount.replacingOccurrences(of: ",", with: ".")
        
        guard let value = Double(amount), value > 0 else {
            throw ValidationError.invalidAmount
        }
        
        return value
    }
    
    static func validate( executionDate: String?) -> Result<String, ValidationError> {
        guard let date = executionDate, !date.trimWhiteSpace().isEmpty else {
            return .failure(.emptyExecutionDate)
        }
        return .success(date)
    }
    
    static func validate( executionTime: String?) -> Result<String, ValidationError> {
        guard let time = executionTime, !time.trimWhiteSpace().isEmpty else {
            return .failure(.emptyExecutionTime)
        }
        return .success(time)
    }
    
    static func validate( executionLocation: String?) -> Result<String, ValidationError> {
        guard let location = executionLocation, !location.trimWhiteSpace().isEmpty else {
            return .failure(.emptyExecutionLocation)
        }
        return .success(location)
    }
    
    static func validate( desc: String?) -> Result<String, ValidationError> {
        guard let desc = desc, !desc.trimWhiteSpace().isEmpty else {
            return .failure(.emptyProblemDetails)
        }
        return .success(desc)
    }

    //MARK: - Services -
    
    static func validate(servicePrice: String?) throws -> String {
        
        guard var price = servicePrice?.trimWhiteSpace(), !price.isEmpty else {
            throw ValidationError.emptyServicePrice
        }
        
        let arabicNumbers = ["٠":"0","١":"1","٢":"2","٣":"3","٤":"4",
                             "٥":"5","٦":"6","٧":"7","٨":"8","٩":"9"]
        arabicNumbers.forEach {
            price = price.replacingOccurrences(of: $0.key, with: $0.value)
        }
        
        // Replace Arabic decimal separator ٫ (U+066B) with a standard dot
        price = price.replacingOccurrences(of: "\u{066B}", with: ".")
        // Replace Arabic thousands separator ٬ (U+066C) with nothing
        price = price.replacingOccurrences(of: "\u{066C}", with: "")
        // Replace Arabic comma ، (U+060C) with a standard dot
        price = price.replacingOccurrences(of: "\u{060C}", with: ".")
        
        price = price.replacingOccurrences(of: " ", with: "")
        
        // Allow only numbers and separators
        let allowed = CharacterSet(charactersIn: "0123456789.,")
        price = String(price.unicodeScalars.filter { allowed.contains($0) })
        
        // Normalize separators
        let separatorCount = price.filter { $0 == "." || $0 == "," }.count
        
        if separatorCount > 1 {
            price = price.replacingOccurrences(of: ".", with: "")
            price = price.replacingOccurrences(of: ",", with: "")
        } else {
            price = price.replacingOccurrences(of: ",", with: ".")
        }
        
        guard let value = Double(price), value > 0 else {
            throw ValidationError.invalidServicePrice
        }

        guard value >= 30 else {
            throw ValidationError.servicePriceBelowMinimum
        }
        return String(format: "%g", value)
    }
    
    static func validate(serviceDescription: String?) throws -> String {
        guard let description = serviceDescription?.trimWhiteSpace(), !description.isEmpty else {
            throw ValidationError.emptyServiceDesc
        }
        guard description.count >= 2 else {
            throw ValidationError.shortServiceDescription
        }
        return description
    }
    
    static func validate(serviceName: String?) throws -> String {
        guard let name = serviceName?.trimWhiteSpace(), !name.isEmpty else {
            throw ValidationError.emptyServiceName
        }
        guard name.count >= 2 else {
            throw ValidationError.shortServiceName
        }
        return name
    }
    
    static func validate(securityCode: String?) throws -> String {
        guard let securityCode = securityCode?.trimWhiteSpace(), !securityCode.isEmpty else {
            throw ValidationError.securityCode
        }
        return securityCode
    }

    //MARK: - Visit Price -

    static func validate(visitPrice: String?) throws -> String {

        guard var price = visitPrice?.trimWhiteSpace(), !price.isEmpty else {
            throw ValidationError.emptyVisitPrice
        }

        let arabicNumbers = ["٠":"0","١":"1","٢":"2","٣":"3","٤":"4",
                             "٥":"5","٦":"6","٧":"7","٨":"8","٩":"9"]
        arabicNumbers.forEach {
            price = price.replacingOccurrences(of: $0.key, with: $0.value)
        }

        price = price.replacingOccurrences(of: "\u{066B}", with: ".")
        price = price.replacingOccurrences(of: "\u{066C}", with: "")
        price = price.replacingOccurrences(of: "\u{060C}", with: ".")
        price = price.replacingOccurrences(of: " ", with: "")

        let allowed = CharacterSet(charactersIn: "0123456789.,")
        price = String(price.unicodeScalars.filter { allowed.contains($0) })

        let separatorCount = price.filter { $0 == "." || $0 == "," }.count
        if separatorCount > 1 {
            price = price.replacingOccurrences(of: ".", with: "")
            price = price.replacingOccurrences(of: ",", with: "")
        } else {
            price = price.replacingOccurrences(of: ",", with: ".")
        }

        guard let value = Double(price), value > 0 else {
            throw ValidationError.invalidVisitPrice
        }

        guard value >= 30 else {
            throw ValidationError.visitPriceBelowMinimum
        }

        return String(format: "%g", value)
    }

    //MARK: - Commercial Registration -

    static func validate(commercialNumber: String?) throws -> String {
        guard let number = commercialNumber?.trimWhiteSpace(), !number.isEmpty else {
            throw ValidationError.emptyCommercialRegistrationNumber
        }
        return number
    }

    @discardableResult
    static func validate(commercialFile: Data?) throws -> Data {
        guard let commercialFile = commercialFile else {
            throw ValidationError.emptyCommercialFile
        }
        return commercialFile
    }

}
