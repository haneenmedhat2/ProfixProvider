//
//  FinancialDetailsVM.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//


import Foundation
import Combine

protocol FinancialDetailsVMProtocol {
    
    var settlements: [FinancialOrders] { get }
    var financialDetails: FinancialDetailsResponse? { get }

    var financialDetailsPublisher: Published<FinancialDetailsResponse?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var id : Int { get }
    var sections: [FinancialSection] { get }
            
    func getFinancialDetails()
    func getFinancialSections(model : TotalValuesModel?)
}

final class FinancialDetailsVM: BaseViewModel,FinancialDetailsVMProtocol {
    
    @Published var financialDetails: FinancialDetailsResponse?
    var financialDetailsPublisher: Published<FinancialDetailsResponse?>.Publisher { $financialDetails }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
  
    var settlements: [FinancialOrders] = []
    var sections: [FinancialSection] = []

    var id : Int
        
    init(id : Int){
        self.id = id
    }

    func getFinancialDetails(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getFinancialDetails(settlementId: id))
                financialDetails = result.data
                getFinancialSections(model : result.data?.totalValues)
                settlements = result.data?.settlementOrders ?? []
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getFinancialSections(model : TotalValuesModel?){
        guard let model = model else { return }
        sections = [.status , .totalValue]
        
        if let reason = model.refuseReason, !reason.isEmpty {
            sections.append(.cancelReason)
           }

           if let image = model.image, !image.isEmpty {
               sections.append(.transferImage)
           }
        sections.append(.breakDown)
    }
}
