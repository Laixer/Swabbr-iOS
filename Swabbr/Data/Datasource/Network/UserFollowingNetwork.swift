//
//  UserFollowingNetwork.swift
//  Swabbr
//
//  Created by James Bal on 09-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowingNetwork: NetworkProtocol, DataSourceSingleMultipleProtocol {
    typealias Entity = User
    
    var endPoint: String = "following"
    
    static let shared = UserFollowingNetwork()
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([User]?) -> Void) {
        load(buildUrl(), withCompletion: { (following) in
            completionHandler(following)
        })
    }
    
    func get(id: String, completionHandler: @escaping (User?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: id)]
        load(buildUrl(queryItems: queryItems)) { (following) in
            completionHandler((following != nil) ? following![0] : nil)
        }
    }
}
