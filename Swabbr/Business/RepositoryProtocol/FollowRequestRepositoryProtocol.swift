//
//  FollowRequestRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol FollowRequestRepositoryProtocol {
    
    /**
     Get a specific FollowRequest from a certain user.
     - parameter id: The id which represents the user of the outgoing request.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: The callback will return an optional UserFollowRequestModel
    */
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void)
    
    /**
     Get all the incoming requests for the authorized account.
     - parameter completionHandler: The callback will return a list of UserFollowRequestModel
    */
    func getIncomingRequests(completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    
    /**
     Get all the outgoing requests from the authorized account.
     - parameter completionHandler: The callback will return a list of UserFollowRequestModel
     */
    func getOutgoingRequests(completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    
    /**
     Create a follow request.
     - parameter userId: The userId which will receive the follow request.
     - parameter completionHandler: The callback will return an UserFollowRequestModel or an optional String
     */
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequestModel?, String?) -> Void)
    
    /**
     Remove the request.
     - parameter userId: The id of the follow request.
     - parameter completionHandler: The callback will return an optional String
     */
    func destroyFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void)
    
    /**
     Accept the request.
     - parameter followRequestId: The id of the follow request.
     - parameter completionHandler: The callback will return an optional String
     */
    func acceptFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void)
    
    /**
     Deny the request.
     - parameter followRequestId: The id of the follow request.
     - parameter completionHandler: The callback will return an optional String
     */
    func declineFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void)
}
