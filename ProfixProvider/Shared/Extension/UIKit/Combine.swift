//
//  Combine.swift
//  Waraqa
//
//  Created by Haneen on 17/08/2025.
//

import Foundation

import Foundation
import Combine

extension Publisher where Self.Failure == Never {
    
    public func sinkOnMain(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        self
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
    }
    
}
