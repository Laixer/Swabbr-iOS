//
//  UserFollowRequestUseCase.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestUseCase {
    
    private let repository: FollowRequestRepositoryProtocol
    
    init(_ repository: FollowRequestRepositoryProtocol = UserFollowRequestRepository()) {
        self.repository = repository
    }
    
    func getIncomingRequests(completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        repository.getIncomingRequests(completionHandler: completionHandler)
    }
    
    func getOutgoingRequests(completionHandler: @escaping ([UserFollowRequestModel]) -> Void) {
        repository.getOutgoingRequests(completionHandler: completionHandler)
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequestModel?, String?) -> Void) {
        repository.createFollowRequest(for: userId, completionHandler: completionHandler)
    }
    
    func destroyFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        repository.destroyFollowRequest(followRequestId: followRequestId, completionHandler: completionHandler)
    }
    
    func acceptFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        repository.acceptFollowRequest(followRequestId: followRequestId, completionHandler: completionHandler)
    }
    
    func declineFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        repository.declineFollowRequest(followRequestId: followRequestId, completionHandler: completionHandler)
    }
}
