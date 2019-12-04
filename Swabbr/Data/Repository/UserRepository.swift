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
    private let cache = UserCacheHandler.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        if refresh {
            network.get(completionHandler: { (users) -> Void in
                guard let users = users else {
                    completionHandler([])
                    return
                }
                completionHandler(
                    users.map({ (user) -> Model in
                        user.mapToBusiness()
                    })
                )
            })
        } else {
            cache.get { (users) in
                guard let users = users else {
                    self.get(refresh: !refresh, completionHandler: completionHandler)
                    return
                }
                completionHandler(
                    users.map({ (user) -> Model in
                        user.mapToBusiness()
                    })
                )
            }
        }
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
        if refresh {
            network.get(id: id, completionHandler: { (user) -> Void in
                completionHandler(user?.mapToBusiness())
            })
        } else {
            cache.get(id: id) { (user) in
                if user == nil {
                    self.get(id: id, refresh: !refresh, completionHandler: completionHandler)
                } else {
                    completionHandler(user?.mapToBusiness())
                }
            }
        }
    }
}
