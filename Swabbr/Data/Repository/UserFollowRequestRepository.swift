//
//  UserFollowRequestRepository.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestRepository: RepositoryMultipleProtocol {
    typealias Model = UserFollowRequestModel
    
    static let shared = UserFollowRequestRepository()
    
    private let network = UserFollowRequestNetwork.shared
    
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([UserFollowRequestModel]?) -> Void) {
        network.get(id: id, multiple: { (userFollowRequests) in
            completionHandler(
                userFollowRequests?.map({ (userFollowRequest) -> Model in
                    userFollowRequest.mapToBusiness()
                })
            )
        })
    }
    
    func get(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]?) -> Void) {
        network.get(completionHandler: { (userFollowRequests) -> Void in
            completionHandler(
                userFollowRequests?.map({ (userFollowRequest) -> Model in
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
