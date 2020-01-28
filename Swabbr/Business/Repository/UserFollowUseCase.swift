//
//  UserFollowingUseCase.swift
//  Swabbr
//
//  Created by James Bal on 09-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowUseCase {
    
    private let repository: UserFollowRepositoryProtocol
    
    init(_ repository: UserFollowRepositoryProtocol = UserFollowRepository()) {
        self.repository = repository
    }
    
    func getFollowers(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        repository.getFollowers(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func getFollowing(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        repository.getFollowing(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func unfollowUser(userId: String, completionHandler: @escaping (String?) -> Void) {
        repository.unfollowUser(userId: userId, completionHandler: completionHandler)
    }
    
}
