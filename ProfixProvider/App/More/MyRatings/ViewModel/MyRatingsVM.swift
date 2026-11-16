//
//  MyRatingsVM.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//


import Foundation
import Combine

protocol MyRatingsVMProtocol {
    
    var reviews : [Reviews] { get }
    var reviewsPublisher: Published<[Reviews]>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func getReviews()
}

final class MyRatingsVM : BaseViewModel , MyRatingsVMProtocol {
    
    @Published var reviews : [Reviews] = []

    var reviewsPublisher: Published<[Reviews]>.Publisher { $reviews }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func getReviews(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getReviews())
                isLoading = false
                reviews = result.data?.reviews ?? []
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
