//
//  OrdersVM.swift
//  Profix
//
//  Created by Haneen on 16/01/2026.
//

import Foundation
import Combine

protocol OrdersVMProtocol {
    
    var orderPublisher: Published<BaseResponse<OrdersResponse>?>.Publisher  { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var currentPage : Int { get }
    var isLastPage: Bool { get }
    
    var ordersList : [Orders] { get }
    var status : String { get set }
    var orderStatusList : [OrderStatus] { get }

    func getOrders()
    func getOrderStatusList()
    func resetData()
}

final class OrdersVM: BaseViewModel,OrdersVMProtocol {
    @Published var orders : BaseResponse<OrdersResponse>?
    
    var orderPublisher: Published<BaseResponse<OrdersResponse>?>.Publisher  { $orders }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
        
    var currentPage:Int = 1
    var isLastPage: Bool = false
    var ordersList : [Orders] = []
    var status : String = ""
    var orderStatusList : [OrderStatus] = []


    func getOrders(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrdersEndPoints.getOrder(page: currentPage, status: status))
                
                let ordersList = result.data?.orders ?? []
                
                if self.currentPage == 1 {
                    self.ordersList.removeAll()
                    self.ordersList = ordersList
                } else {
                    self.ordersList.append(contentsOf: ordersList)
                }
                
                self.isLastPage = result.data?.pagination.isLastPage ?? false
                if !isLastPage {
                    self.currentPage += 1
                }
                
                orders = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getOrderStatusList(){
        status = OrderStatus.open.apiValue
        orderStatusList = [.open , .inprogress , .finished]
    }

    func resetData(){
        currentPage = 1
        isLastPage = false
    }
}
