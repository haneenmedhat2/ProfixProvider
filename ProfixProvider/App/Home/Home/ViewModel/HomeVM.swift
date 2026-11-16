//
//  HomeVM.swift
//  Profix
//
//  Created by Haneen on 31/12/2025.
//


import Foundation
import Combine

protocol HomeVMProtocol {
    var homePublisher: Published<HomeResponse?>.Publisher { get }
    var availabilityPublisher: Published<User?>.Publisher { get }
    var sitePhonePublisher: Published<String?>.Publisher { get }


    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }

    var ads : [Ad] { get }
    var ordersList : [Orders] { get }
    var statistics : [OrderStatistics] { get }
    var currentPage : Int { get }
    var isLastPage: Bool { get }
    func homeRequest()
    func resetData()
    func changeLanguageRequest()
    func getAvailability()
    func getSitePhone()

}

final class HomeVM : BaseViewModel , HomeVMProtocol {
    @Published var home: HomeResponse?
    @Published var availability: User?
    @Published var sitePhone: String?

    var homePublisher: Published<HomeResponse?>.Publisher { $home }
    var availabilityPublisher: Published<User?>.Publisher { $availability }
    var sitePhonePublisher: Published<String?>.Publisher { $sitePhone }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var ads : [Ad] = []
    var ordersList : [Orders] = []
    var statistics : [OrderStatistics] = []
    var currentPage:Int = 1
    var isLastPage: Bool = false

    func getSitePhone() {
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.sitePhone())
                sitePhone = result.data?.sitePhone
            } catch {
                print("Failed to load site phone: \(error.localizedDescription)")
            }
        }
    }
    
    func homeRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(HomeEndPoints.getHomeData())
                let ordersList = result.data?.orders ?? []
                
                if currentPage == 1 {
                    self.ordersList.removeAll()
                    self.ordersList = ordersList
                } else {
                    self.ordersList.append(contentsOf: ordersList)
                }
                
                isLastPage = result.data?.pagination?.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                
                
                ads = result.data?.ads ?? []
                statistics = result.data?.getOrderStatisticsList() ?? []
                isLoading = false
                home = result.data
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func resetData(){
        currentPage = 1
        isLastPage = false
    }
    
    func changeLanguageRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.changeLanguage())
                isLoading = false
                Session.user = result.data?.user

            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func getAvailability() {
        Task {
            do {
                let result = try await getAllRequest(HomeEndPoints.getAvailability())
                guard let user = result.data?.user else { return }
                Session.user = user
                availability = user
            } catch {
                self.error = error
            }
        }
    }

}
