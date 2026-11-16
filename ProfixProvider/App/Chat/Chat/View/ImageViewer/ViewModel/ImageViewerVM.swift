//
//  ImageViewerVM.swift
//  Esterad
//
//  Created by Haneen on 10/12/2025.
//

import Foundation
import Combine

protocol ImageViewerVMProtocol {
    
    var image: ProblemDescImageType { get }
}

final class ImageViewerVM: BaseViewModel,ImageViewerVMProtocol {
    
    var image: ProblemDescImageType

    
    init(image: ProblemDescImageType){
        self.image = image
    }
}
