//
//  UserFollowRequestRepository.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestRepository: RepositorySingleMultipleProtocol, RepositoryAllProtocol {
    typealias Model = UserFollowRequestModel
    
    private let network: DataSourceFactory<UserFollowRequest>
    
    init(network: DataSourceFactory<UserFollowRequest> = DataSourceFactory(UserFollowRequestNetwork.shared)) {
        self.network = network
    }
    
    func getSingleMultiple(id: Int, refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
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
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void) {
        network.get(id: id, completionHandler: { (userFollowRequest) -> Void in
            completionHandler(userFollowRequest?.mapToBusiness())
        })
    }
}
