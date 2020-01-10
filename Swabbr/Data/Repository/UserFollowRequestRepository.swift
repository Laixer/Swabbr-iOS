//
//  UserFollowRequestRepository.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestRepository: FollowRequestRepositoryProtocol {
    
    private let network: FollowRequestDataSourceProtocol
    
    init(network: FollowRequestDataSourceProtocol = UserFollowRequestNetwork()) {
        self.network = network
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        network.getSingleMultiple(id: id, completionHandler: { (userFollowRequests) in
            completionHandler(
                userFollowRequests.map({ (userFollowRequest) -> UserFollowRequestModel in
                    userFollowRequest.mapToBusiness()
                })
            )
        })
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        network.getAll(completionHandler: { (userFollowRequests) -> Void in
            completionHandler(
                userFollowRequests.map({ (userFollowRequest) -> UserFollowRequestModel in
                    userFollowRequest.mapToBusiness()
                })
            )
        })
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void) {
        network.get(id: id, completionHandler: { (userFollowRequest) -> Void in
            completionHandler(userFollowRequest?.mapToBusiness())
        })
    }
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequestModel?, String?) -> Void) {
        network.createFollowRequest(for: userId, completionHandler: { (userFollowRequest, errorString) -> Void in
            completionHandler(userFollowRequest?.mapToBusiness(), errorString)
        })
    }
    
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (String?) -> Void) {
        network.destroyFollowRequest(for: userId, completionHandler: completionHandler)
    }
    
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void) {
        network.acceptFollowRequest(from: userId, completionHandler: completionHandler)
    }
    
    func declineFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void) {
        network.declineFollowRequest(from: userId, completionHandler: completionHandler)
    }
}
