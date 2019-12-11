//
//  FollowStatusUseCase.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class FollowStatusUseCase {
    
    private let repository: RepositoryFactory<FollowStatusModel>
    
    init(_ repository: RepositoryFactory<FollowStatusModel> = RepositoryFactory(FollowStatusRepository())) {
        self.repository = repository
    }
    
    func get(refresh: Bool, completionHandler: @escaping ([FollowStatusModel]) -> Void) {
        repository.getAll(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (FollowStatusModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
}
