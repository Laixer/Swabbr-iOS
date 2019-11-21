//
//  Repository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class UserRepository: RepositoryProtocol {
    typealias Model = UserModel
    
    static let shared = UserRepository()
    
    private let network = UserNetwork.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([UserModel]?) -> Void) {
        network.get(completionHandler: { (users) -> Void in
            completionHandler(
                users?.map({ (user) -> Model in
                    user.mapToBusiness()
                })
            )
        })
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
        network.get(id: id, completionHandler: { (user) -> Void in
            completionHandler(user?.mapToBusiness())
        })
    }
}
