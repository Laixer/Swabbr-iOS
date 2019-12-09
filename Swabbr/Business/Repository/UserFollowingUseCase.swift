//
//  UserFollowingUseCase.swift
//  Swabbr
//
//  Created by James Bal on 09-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowingUseCase {
    
    private let repository: RepositoryFactory<UserModel>
    
    init(_ repository: RepositoryFactory<UserModel> = RepositoryFactory(UserFollowingRepository())) {
        self.repository = repository
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        repository.getSingleMultiple(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
}
