//
//  UserFollowRequestNetwork.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowRequestNetwork: NetworkProtocol, DataSourceMultipleProtocol {
    
    typealias Entity = UserFollowRequest
    
    static let shared = UserFollowRequestNetwork()
    
    var endPoint: String = "followRequests"
    
    func get(completionHandler: @escaping ([UserFollowRequest]?) -> Void) {
        load(buildUrl()) { (userFollowRequests) in
            completionHandler(userFollowRequests)
        }
    }
    
    func get(id: Int, completionHandler: @escaping (UserFollowRequest?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (userFollowRequests) in
            completionHandler((userFollowRequests != nil) ? userFollowRequests![0] : nil)
        }
    }
    
    func get(id: Int, multiple completionHandler: @escaping ([UserFollowRequest]?) -> Void) {
        let queryItems = [URLQueryItem(name: "requesterId", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (userFollowRequests) in
            completionHandler(userFollowRequests)
        }
    }
    
}
