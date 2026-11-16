//
//  RoomsVMProtocol.swift
//  Esterad
//
//  Created by Haneen on 07/12/2025.
//


import Foundation
import Combine

protocol RoomsVMProtocol {
    
    var chatRoomsPublisher: Published<BaseResponse<RoomsResponse>?>.Publisher { get }
    var searchSubject : PassthroughSubject<String, Never> { get set }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var roomsList : [RoomModel] { get }
    var searchQuery : String? { get set }
    var currentPage : Int { get }
    var isLastPage: Bool { get }
    
    func getRooms()
    func resetData()
}

final class RoomsVM: BaseViewModel,RoomsVMProtocol {
    
    @Published var chatRooms: BaseResponse<RoomsResponse>?

    var chatRoomsPublisher: Published<BaseResponse<RoomsResponse>?>.Publisher { $chatRooms }
    var searchSubject = PassthroughSubject<String, Never>()

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var roomsList : [RoomModel] = []
    var searchQuery : String?
    var currentPage:Int = 1
    var isLastPage: Bool = false

    func getRooms(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ChatEndPoints.getRooms(name: searchQuery, page: currentPage))
                
                let roomsList = result.data?.rooms ?? []
                
                if currentPage == 1 {
                    self.roomsList.removeAll()
                    self.roomsList = roomsList
                } else {
                    self.roomsList.append(contentsOf: roomsList)
                }
                
                isLastPage = result.data?.pagination?.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                
                chatRooms = result
                isLoading = false

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
}
