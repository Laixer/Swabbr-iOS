//
//  FollowRequestDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol FollowRequestDataSourceProtocol {
    
    /**
     Get a specific FollowRequest from a certain user.
     - parameter id: The id which represents the user of the outgoing request.
     - parameter completionHandler: The callback will return an optional UserFollowRequest
     */
    func get(id: String, completionHandler: @escaping (UserFollowRequest?) -> Void)
    
    /**
     Get all the incoming requests for the authorized account.
     - parameter completionHandler: The callback will return a list of UserFollowRequest
     */
    func getIncomingRequests(completionHandler: @escaping ([UserFollowRequest]) -> Void)
    
    /**
     Get all the outgoing requests from the authorized account.
     - parameter completionHandler: The callback will return a list of UserFollowRequest
     */
    func getOutgoingRequests(completionHandler: @escaping ([UserFollowRequest]) -> Void)
    
    /**
     Create a follow request.
     - parameter userId: The userId which will receive the follow request.
     - parameter completionHandler: The callback will return an UserFollowRequest or an optional String
     */
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequest?, String?) -> Void)
    
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
