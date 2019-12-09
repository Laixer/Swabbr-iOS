//
//  Network.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserNetwork: NetworkProtocol, DataSourceAllProtocol, DataSourceSearchTermProtocol {
    static let shared = UserNetwork()
    
    var endPoint: String = "users"

    func getAll(completionHandler: @escaping ([User]?) -> Void) {
        load(buildUrl()) { (users) in
            UserCacheHandler.shared.set(objects: users)
            completionHandler(users)
        }
    }
    
    func get(id: String, completionHandler: @escaping (User?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: id)]
        load(buildUrl(queryItems: queryItems)) { (users) in
            let user = (users != nil) ? users![0] : nil
            UserCacheHandler.shared.set(object: user)
            completionHandler(user)
        }
    }
    
    func get(term: String, completionHandler: @escaping ([User]?) -> Void) {
        // TODO: search for the user
        completionHandler([])
    }
}
