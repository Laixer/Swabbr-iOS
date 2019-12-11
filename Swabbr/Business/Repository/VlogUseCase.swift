//
//  VlogUseCase.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogUseCase {
    
    private let repository: RepositoryFactory<VlogModel>
    
    init(_ repository: RepositoryFactory<VlogModel> = RepositoryFactory(VlogRepository())) {
        self.repository = repository
    }
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        repository.getAll(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        repository.getSingleMultiple(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func createLike(id: String, completionHandler: @escaping (Int) -> Void) {
        repository.createLike(id: id, completionHandler: completionHandler)
    }
    
    func createVlog(completionHandler: @escaping (Int) -> Void) {
        repository.createVlog(completionHandler: completionHandler)
    }
}
