//
//  BookingLocationVM.swift
//  Profix
//
//  Created by Haneen on 12/01/2026.
//

import Foundation
import Combine

protocol BookingLocationVMProtocol {
    
    var onLocationSelected: ((AddressModel) -> Void)? { get set}
    var selectedAddress: AddressModel? { get set }
    var locationMode : LocationMode { get }
}

final class BookingLocationVM : BaseViewModel , BookingLocationVMProtocol {
    
    var onLocationSelected: ((AddressModel) -> Void)?
    var selectedAddress: AddressModel?
    var locationMode : LocationMode
    
    init(locationMode: LocationMode, selectedAddress: AddressModel? = nil) {
        self.locationMode = locationMode
        self.selectedAddress = selectedAddress
    }

}
