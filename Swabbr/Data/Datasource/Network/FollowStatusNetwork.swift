//
//  FollowStatusNetwork.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class FollowStatusNetwork: NetworkProtocol, DataSourceAllProtocol {
    
    typealias Entity = FollowStatus
    
    static let shared = FollowStatusNetwork()
    
    var endPoint: String = "followStatus"
    
    func getAll(completionHandler: @escaping ([FollowStatus]?) -> Void) {
        load(buildUrl()) { (followStatuses) in
            completionHandler(followStatuses)
        }
    }
    
    func get(id: String, completionHandler: @escaping (FollowStatus?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (followStatuses) in
            completionHandler((followStatuses != nil) ? followStatuses![0] : nil)
        }
    }
}
