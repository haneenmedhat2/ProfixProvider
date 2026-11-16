//
//  IntroVM.swift
//  Profix
//
//  Created by Haneen on 08/12/2025.
//


import Foundation
import Combine
import Kingfisher

protocol IntroVMProtocol {
    
    var introPublisher: Published<[IntroModel]?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var introList : [IntroModel] { get set }
    var currentIndex : Int { get set }
    
    func introRequest()
}

final class IntroVM: BaseViewModel,IntroVMProtocol {
    @Published var intro: [IntroModel]?

    var introPublisher: Published<[IntroModel]?>.Publisher { $intro }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var introList : [IntroModel] = []
    var currentIndex : Int = 0
    private var imagePrefetcher: ImagePrefetcher?


    func introRequest(){
        // Reuse the request started by the splash screen, including its loaded result.
        guard !isLoading, intro == nil else { return }
        error = nil
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.introRequest())
                introList = result.data?.intros ?? []
                let imageURLs = introList.compactMap { item -> URL? in
                    guard let image = item.image else { return nil }
                    guard let url = URL(string: image),
                          IntroImageAssets.image(for: url) == nil else { return nil }
                    return url
                }
                imagePrefetcher = ImagePrefetcher(urls: imageURLs, options: [.backgroundDecode])
                imagePrefetcher?.start()
                intro = introList
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
