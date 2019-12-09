//
//  UserFollowersNetwork.swift
//  Swabbr
//
//  Created by James Bal on 05-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowersNetwork: NetworkProtocol, DataSourceSingleMultipleProtocol {
    typealias Entity = User
    
    var endPoint: String = "followers"
    
    static let shared = UserFollowersNetwork()
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([User]?) -> Void) {
        load(buildUrl(), withCompletion: { (followers) in
            completionHandler(followers)
        })
    }
    
    func get(id: String, completionHandler: @escaping (User?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: id)]
        load(buildUrl(queryItems: queryItems)) { (followers) in
            completionHandler((followers != nil) ? followers![0] : nil)
        }
    }
}
