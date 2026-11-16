//
//  WorkDetailsVM.swift
//  ProfixProvider
//
//  Created by Haneen on 05/02/2026.
//


import Foundation
import Combine

protocol WorkDetailsVMProtocol {
    var workDetailsPublisher: Published<Works?>.Publisher { get }
    var deleteWorkPublisher: Published<BaseResponse<String>?>.Publisher { get }
    
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var workId : Int { get }
    var workDetails: Works? { get }
    func getWorkDetailsRequest()
    func deleteWorkRequest()
}

final class WorkDetailsVM: BaseViewModel,WorkDetailsVMProtocol {
    
    @Published var workDetails: Works?
    @Published var deleteWork: BaseResponse<String>?
    
    var workDetailsPublisher: Published<Works?>.Publisher { $workDetails }
    var deleteWorkPublisher: Published<BaseResponse<String>?>.Publisher { $deleteWork }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var workId : Int
    init(workId : Int){
        self.workId = workId
    }
    
    func getWorkDetailsRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getWorkDetails(id: workId))
                workDetails = result.data?.work
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteWorkRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.deleteWork(id: workId))
                deleteWork = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
