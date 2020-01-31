//
//  LivestreamRepository.swift
//  Swabbr
//
//  Created by James Bal on 20-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class LivestreamRepository: LivestreamRepositoryProtocol {
    
    private let network: LivestreamDataSourceProtocol
    
    init(network: LivestreamDataSourceProtocol = LivestreamNetwork()) {
        self.network = network
    }
    
    func start(id: String, completionHandler: @escaping (String?) -> Void) {
        network.start(id: id, completionHandler: completionHandler)
    }
    
    func stop(id: String, completionHandler: @escaping (String?) -> Void) {
        network.stop(id: id, completionHandler: completionHandler)
    }
    
    func publish(id: String, completionHandler: @escaping (String?) -> Void) {
        network.publish(id: id, completionHandler: completionHandler)
    }
    
}
