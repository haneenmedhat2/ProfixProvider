//
//  FinancialDueVMProtocol.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//


import Foundation
import Combine

protocol NewFinancialTransVMProtocol {
    
    var newSettlements: [FinancialTransModel] { get }
    
    var newSettlementsPublisher: Published<[FinancialTransModel]>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var mode : SettlementMode { get }
            
    func getNewSettlements()
    func getFinishedSettlements()

}

final class NewFinancialTransVM: BaseViewModel,NewFinancialTransVMProtocol {
    
    @Published var newSettlements: [FinancialTransModel] = []

    var newSettlementsPublisher: Published<[FinancialTransModel]>.Publisher{ $newSettlements }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
  
    var mode : SettlementMode
    
    init(mode : SettlementMode){
        self.mode = mode
    }

    func getNewSettlements(){
        newSettlements = []
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getNewSettlements())
                newSettlements = result.data ?? []
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getFinishedSettlements(){
        newSettlements = []
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getFinishedSettlements())
                newSettlements = result.data ?? []
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
