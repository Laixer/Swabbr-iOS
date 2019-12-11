//
//  UserFollowRequestUseCase.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestUseCase {
    
    private let repository: RepositoryFactory<UserFollowRequestModel>
    
    init(_ repository: RepositoryFactory<UserFollowRequestModel> = RepositoryFactory(UserFollowRequestRepository())) {
        self.repository = repository
    }
    
    func get(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        repository.getAll(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        repository.getSingleMultiple(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        repository.createFollowRequest(id: userId, completionHandler: completionHandler)
    }
    
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        repository.destroyFollowRequest(id: userId, completionHandler: completionHandler)
    }
    
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        repository.acceptFollowRequest(id: userId, completionHandler: completionHandler)
    }
    
    func declineFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        repository.declineFollowRequest(id: userId, completionHandler: completionHandler)
    }
}
