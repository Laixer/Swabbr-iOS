//
//  UserFollowRequestRepository.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestRepository: FollowRequestRepositoryProtocol {
    
    typealias Model = UserFollowRequestModel
    
    private let network: DataSourceFactory<UserFollowRequest>
    
    init(network: DataSourceFactory<UserFollowRequest> = DataSourceFactory(UserFollowRequestNetwork.shared)) {
        self.network = network
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        network.getSingleMultiple(id: id, completionHandler: { (userFollowRequests) in
            guard let userFollowRequests = userFollowRequests else {
                completionHandler([])
                return
            }
            completionHandler(
                userFollowRequests.map({ (userFollowRequest) -> Model in
                    userFollowRequest.mapToBusiness()
                })
            )
        })
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        network.getAll(completionHandler: { (userFollowRequests) -> Void in
            completionHandler(
                userFollowRequests!.map({ (userFollowRequest) -> Model in
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
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        network.createFollowRequest(id: userId, completionHandler: completionHandler)
    }
    
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        network.destroyFollowRequest(id: userId, completionHandler: completionHandler)
    }
    
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        network.acceptFollowRequest(id: userId, completionHandler: completionHandler)
    }
    
    func declineFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        network.declineFollowRequest(id: userId, completionHandler: completionHandler)
    }
}
