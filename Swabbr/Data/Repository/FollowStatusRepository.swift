//
//  FollowStatusRepository.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class FollowStatusRepository: RepositoryProtocol, RepositoryAllProtocol {
    
    typealias Model = FollowStatusModel
    
    private let network: DataSourceFactory<FollowStatus>
    
    init(network: DataSourceFactory<FollowStatus> = DataSourceFactory(FollowStatusNetwork.shared)) {
        self.network = network
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([FollowStatusModel]) -> Void) {
        network.getAll(completionHandler: { (followStatuses) -> Void in
            guard let followStatuses = followStatuses else {
                completionHandler([])
                return
            }
            completionHandler(
                followStatuses.map({ (followStatuses) -> Model in
                    followStatuses.mapToBusiness()
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
