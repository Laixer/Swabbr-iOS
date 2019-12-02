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

    func get(completionHandler: @escaping ([User]) -> Void) {
        load(buildUrl()) { (users) in
            completionHandler(users)
        }
    }
    
    func get(id: Int, completionHandler: @escaping (User?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (users) in
            completionHandler((!users.isEmpty) ? users[0] : nil)
        }
    }
}
