//
//  UserFollowerRepository.swift
//  Swabbr
//
//  Created by James Bal on 05-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRepository: UserFollowRepositoryProtocol {
    
    private let network: UserFollowDataSourceProtocol
    
    init(network: UserFollowDataSourceProtocol = UserFollowNetwork()) {
        self.network = network
    }
    
    func getFollowers(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        network.getFollowers(id: id, completionHandler: { (followers) in
            completionHandler(
                followers.map({ (follower) -> UserModel in
                    follower.mapToBusiness()
                })
            )
        })
    }
    
    func getFollowing(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        network.getFollowing(id: id, completionHandler: { (followings) in
            completionHandler(
                followings.map({ (following) -> UserModel in
                    following.mapToBusiness()
                })
            )
        })
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (FollowStatusModel?) -> Void) {
        network.get(id: id, completionHandler: { (followStatus) in
            completionHandler(followStatus?.mapToBusiness())
        })
    }
    
    
    
}

