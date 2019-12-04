//
//  Network.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserNetwork: NetworkProtocol {
    typealias Entity = User
    
    static let shared = UserNetwork()
    
    var endPoint: String = "/users"

    func get(completionHandler: @escaping ([User]?) -> Void) {
        load(buildUrl()) { (users) in
            UserCacheHandler.shared.set(objects: users)
            completionHandler(users)
        }
    }
    
    func get(id: Int, completionHandler: @escaping (User?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (users) in
            let user = (users != nil) ? users![0] : nil
            UserCacheHandler.shared.set(object: user)
            completionHandler(user)
        }
    }
}
