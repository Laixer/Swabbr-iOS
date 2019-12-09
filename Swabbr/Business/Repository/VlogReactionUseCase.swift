//
//  VlogReactionUseCase.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogReactionUseCase {
    
    private let repository: RepositoryFactory<VlogReactionModel>
    
    init(_ repository: RepositoryFactory<VlogReactionModel> = RepositoryFactory(VlogReactionRepository())) {
        self.repository = repository
    }
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        repository.getAll(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func getSingleMultiple(id: Int, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        repository.getSingleMultiple(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    
}
