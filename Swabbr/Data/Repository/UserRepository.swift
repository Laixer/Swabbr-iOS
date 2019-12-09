//
//  UserRepository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class UserRepository: RepositoryProtocol, RepositoryAllProtocol {
    typealias Model = UserModel
    
    private let network: DataSourceFactory<User>
    private let cache: DataSourceFactory<User>
    
    init(network: DataSourceFactory<User> = DataSourceFactory(UserNetwork.shared), cache: DataSourceFactory<User> = DataSourceFactory(UserCacheHandler.shared)) {
        self.network = network
        self.cache = cache
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        if refresh {
            network.getAll(completionHandler: { (users) -> Void in
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
            cache.getAll { (users) in
                guard let users = users else {
                    self.getAll(refresh: !refresh, completionHandler: completionHandler)
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
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
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
    
//    func get(term: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
//        network.get(term: term, completionHandler: { (users) -> Void in
//            guard let users = users else {
//                completionHandler([])
//                return
//            }
//            completionHandler(
//                users.map({ (user) -> Model in
//                    user.mapToBusiness()
//                })
//            )
//        })
//    }
    
}
