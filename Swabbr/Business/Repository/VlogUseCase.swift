//
//  VlogUseCase.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogUseCase {
    
    private let repository: VlogRepositoryProtocol
    
    init(_ repository: VlogRepositoryProtocol = VlogRepository()) {
        self.repository = repository
    }
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        repository.getFeatured(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func getUserVlogs(id: String, refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        repository.getUserVlogs(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func createLike(id: String, completionHandler: @escaping (String?) -> Void) {
        repository.createLike(id: id, completionHandler: completionHandler)
    }
    
    func createVlog(completionHandler: @escaping (String?) -> Void) {
        repository.createVlog(completionHandler: completionHandler)
    }
}
