//
//  UserFollowRequestNetwork.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestNetwork: NetworkProtocol, FollowRequestDataSourceProtocol {
    
    typealias Entity = UserFollowRequest
    
    static let shared = UserFollowRequestNetwork()
    
    var endPoint: String = "followRequests"
    
    func getAll(completionHandler: @escaping ([UserFollowRequest]?) -> Void) {
        load(buildUrl()) { (userFollowRequests) in
            completionHandler(userFollowRequests)
        }
    }
    
    func get(id: String, completionHandler: @escaping (UserFollowRequest?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: id)]
        load(buildUrl(queryItems: queryItems)) { (userFollowRequests) in
            completionHandler((userFollowRequests != nil) ? userFollowRequests![0] : nil)
        }
    }
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([UserFollowRequest]?) -> Void) {
        let queryItems = [URLQueryItem(name: "userId", value: id)]
        load(buildUrl(queryItems: queryItems)) { (userFollowRequests) in
            completionHandler(userFollowRequests)
        }
    }
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        post(buildUrl(), withCompletion: { (responseCode) in
            completionHandler(responseCode)
        })
    }
    
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        post(buildUrl(), withCompletion: { (responseCode) in
            completionHandler(responseCode)
        })
    }
    
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        post(buildUrl(), withCompletion: { (responseCode) in
            completionHandler(responseCode)
        })
    }
    
    func declineFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        post(buildUrl(), withCompletion: { (responseCode) in
            completionHandler(responseCode)
        })
    }
    
}
