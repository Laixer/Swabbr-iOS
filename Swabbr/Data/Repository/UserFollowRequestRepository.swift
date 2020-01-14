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
    
    func getIncomingRequests(completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        network.getIncomingRequests(completionHandler: { (userFollowRequests) -> Void in
            completionHandler(
                userFollowRequests.map({ (followRequest) -> UserFollowRequestModel in
                    followRequest.mapToBusiness()
                })
            )
        })
    }
    
    func getOutgoingRequests(completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        network.getOutgoingRequests(completionHandler: { (userFollowRequests) -> Void in
            completionHandler(
                userFollowRequests.map({ (followRequest) -> UserFollowRequestModel in
                    followRequest.mapToBusiness()
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
    
    func destroyFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        network.destroyFollowRequest(followRequestId: followRequestId, completionHandler: completionHandler)
    }
    
    func acceptFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        network.acceptFollowRequest(followRequestId: followRequestId, completionHandler: completionHandler)
    }
    
    func declineFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        network.declineFollowRequest(followRequestId: followRequestId, completionHandler: completionHandler)
    }
}
