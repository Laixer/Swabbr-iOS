//
//  FollowRequestRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol FollowRequestRepositoryProtocol {
    
    /**
     Get a specific follow status from a certain user.
     - parameter id: The id which represents the user of the outgoing request.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: The callback will return an optional UserFollowRequestModel
    */
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void)
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    
    /**
     Create a follow request.
     - parameter userId: The userId which will receive the follow request.
     - parameter completionHandler: The callback will return an UserFollowRequestModel or an optional String
     */
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequestModel?, String?) -> Void)
    
    /**
     Remove the request.
     - parameter userId: The userId for which the given follow request will be removed.
     - parameter completionHandler: The callback will return an optional String
     */
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (String?) -> Void)
    
    /**
     Accept the request.
     - parameter userId: The userId from which the follow request originated will be accepted.
     - parameter completionHandler: The callback will return an optional String
     */
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void)
    
    /**
     Deny the request.
     - parameter userId: The userId from which the follow request originated will be rejected.
     - parameter completionHandler: The callback will return an optional String
     */
    func declineFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void)
}
