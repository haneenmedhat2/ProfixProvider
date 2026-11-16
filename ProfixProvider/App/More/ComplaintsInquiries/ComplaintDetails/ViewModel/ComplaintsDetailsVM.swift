//
//  ComplaintsDetailsVM.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//


import Foundation
import Combine

protocol ComplaintsDetailsVMProtocol {
    
    var rowsPublisher: Published<[ComplaintDetailsRow]>.Publisher { get }
    var rows: [ComplaintDetailsRow] { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var id : Int { get }
    
    func getComplaintsDetails()
}

final class ComplaintsDetailsVM: BaseViewModel,ComplaintsDetailsVMProtocol {
    
    @Published private(set) var rows: [ComplaintDetailsRow] = []
    var rowsPublisher: Published<[ComplaintDetailsRow]>.Publisher { $rows }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var id : Int
    
    init(id : Int){
        self.id = id
    }
    
    func getComplaintsDetails(){
        isLoading = true
        Task {  @MainActor in
            do {
                let result = try await getAllRequest(MoreEndpoints.complaintDetails( id: id))
                
                if let model = result.data?.ticket {
                    self.rows = model.toRows()
                }
                
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
