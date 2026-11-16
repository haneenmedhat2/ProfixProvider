//
//  FinancialDueVM.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//

import Foundation
import Combine

protocol FinancialDueVMProtocol {
    
    var financialDue: FinancialDueModel? { get }
    
    var financialDuePublisher: Published<FinancialDueModel?>.Publisher { get }
    var settlementPublisher: Published<BaseResponse<String>?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
            
    var ordersList : [FinancialOrders] { get }
    func getSettlements()
    func settlementRequest(model : Settlement)
}

final class FinancialDueVM: BaseViewModel,FinancialDueVMProtocol {
    
    @Published var financialDue: FinancialDueModel?
    @Published var settlement: BaseResponse<String>?

    var financialDuePublisher: Published<FinancialDueModel?>.Publisher { $financialDue }
    var settlementPublisher: Published<BaseResponse<String>?>.Publisher { $settlement }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var ordersList : [FinancialOrders] = []

    func getSettlements(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getWaitingSettlementsOrders())
                financialDue = result.data
                ordersList = result.data?.orders ?? []
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func settlementRequest(model : Settlement){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.settlementRequest(model: model))
                settlement = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
