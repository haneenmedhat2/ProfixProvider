//
//  ComplaintsVM.swift
//  Profix
//
//  Created by Haneen on 25/12/2025.
//

import Foundation
import Combine

protocol ComplaintsVMProtocol {
    
    var complaintsPublisher: Published<BaseResponse<ComplaintsResponse>?>.Publisher  { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
 
    var complaintsList : [ComplaintModel] { get }
    var status : String { get set }
    var complaintsStatusList : [OrderStatus] { get }

    func getComplaints()
    func getOrderStatusList()
}

final class ComplaintsVM: BaseViewModel,ComplaintsVMProtocol {
    @Published var complaints : BaseResponse<ComplaintsResponse>?
    
    var complaintsPublisher: Published<BaseResponse<ComplaintsResponse>?>.Publisher  { $complaints }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }

    var complaintsList : [ComplaintModel] = []
    var status : String = "open"
    var complaintsStatusList : [OrderStatus] = []

    func getComplaints(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints
                    .getComplaints( status: status))
                complaintsList = result.data?.tickets ?? []
                complaints = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getOrderStatusList(){
        status = OrderStatus.open.apiValue
        complaintsStatusList = [.open , .complaintInprogress , .finished]
    }
}
