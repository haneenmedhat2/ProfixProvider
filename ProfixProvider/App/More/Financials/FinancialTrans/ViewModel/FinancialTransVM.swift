//
//  FinancialTransVM.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//


import Foundation
import Combine

protocol FinancialTransVMProtocol {
    
    var orderStatusList : [OrderStatus] { get }
    var currentIndex: Int { get set }
}

final class FinancialTransVM: BaseViewModel,FinancialTransVMProtocol {
    
    var orderStatusList : [OrderStatus] = [.due , .open , .finished]
    var currentIndex: Int = 0
}
