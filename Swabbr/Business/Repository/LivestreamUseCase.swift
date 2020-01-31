//
//  LivestreamUseCase.swift
//  Swabbr
//
//  Created by James Bal on 20-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class LivestreamUseCase {
    
    private let repository: LivestreamRepositoryProtocol
    
    init(repository: LivestreamRepositoryProtocol = LivestreamRepository()) {
        self.repository = repository
    }
    
    func start(id: String, completionHandler: @escaping (String?) -> Void) {
        repository.start(id: id, completionHandler: completionHandler)
    }
    
    func stop(id: String, completionHandler: @escaping (String?) -> Void) {
        repository.stop(id: id, completionHandler: completionHandler)
    }
    
    func publish(id: String, completionHandler: @escaping (String?) -> Void) {
        repository.publish(id: id, completionHandler: completionHandler)
    }
    
}
