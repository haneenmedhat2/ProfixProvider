//
//  ChatVM.swift
//  Esterad
//
//  Created by Haneen on 07/12/2025.
//

import Foundation
import Combine

protocol ChatVMProtocol {
    
    var singleRoomPublisher: Published<BaseResponse<SingleRoomResponse>?>.Publisher { get }
    var uploadFilePublisher: Published<BaseResponse<UploadFileResponse>?>.Publisher { get }
    var messageText : CurrentValueSubject<String,Never> { get }
    var isSendEnabled : AnyPublisher<Bool,Never> { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var messagesList : [ChatMessage] { get set }
    var currentPage : Int { get }
    var isLastPage: Bool { get }
    var roomId : Int { get }
    var delegateId : Int? { get }

    func getSingleRoom()
    func uploadFileRequest(model : UploadFileModel)
    func resetData()

}

final class ChatVM: BaseViewModel,ChatVMProtocol {
    
    @Published var singleRoom: BaseResponse<SingleRoomResponse>?
    @Published var uploadFile: BaseResponse<UploadFileResponse>?

    var singleRoomPublisher: Published<BaseResponse<SingleRoomResponse>?>.Publisher { $singleRoom }
    var uploadFilePublisher: Published<BaseResponse<UploadFileResponse>?>.Publisher { $uploadFile }
    var messageText : CurrentValueSubject<String,Never> = .init("")
    var isSendEnabled : AnyPublisher<Bool,Never> {
        messageText
            .map {!$0.trimWhiteSpace().isEmpty}
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var messagesList : [ChatMessage] = []
    var currentPage:Int = 1
    var isLastPage: Bool = false
    var roomId : Int
    var delegateId : Int?


    init(roomId : Int){
        self.roomId = roomId
    }
    
    func getSingleRoom(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ChatEndPoints.getSingleRoom(page: currentPage, roomId : roomId))
                
                let messagesList = result.data?.room.messages ?? []
          
                if currentPage == 1 {
                    self.messagesList.removeAll()
                    self.messagesList = messagesList
                } else {
                    self.messagesList.append(contentsOf: messagesList)
                }
                
                isLastPage = result.data?.room.pagination.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                isLoading = false
                singleRoom = result
                delegateId = result.data?.room.receiverId
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func uploadFileRequest(model : UploadFileModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ChatEndPoints.uploadFile(model: model))
                isLoading = false
                uploadFile = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func resetData() {
        currentPage = 1
        isLastPage = false
    }
}
