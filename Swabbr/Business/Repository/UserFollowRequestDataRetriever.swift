//
//  UserFollowRequestDataRetriever.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestDataRetriever: RepositoryMultipleProtocol {
    typealias Model = UserFollowRequestModel
    
    static let shared = UserFollowRequestDataRetriever()
    
    private let repository = UserFollowRequestRepository.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]?) -> Void) {
        repository.get(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([UserFollowRequestModel]?) -> Void) {
        repository.get(id: id, refresh: refresh, multiple: completionHandler)
    }
}
