//
//  UserRepository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class UserRepository: UserRepositoryProtocol {
    
    private let network: UserDataSourceProtocol
    private let cache: UserCacheDataSourceProtocol
    
    init(network: UserDataSourceProtocol = UserNetwork(), cache: UserCacheDataSourceProtocol = UserCacheHandler.shared) {
        self.network = network
        self.cache = cache
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        if refresh {
            network.getAll(completionHandler: { (users) -> Void in
                self.cache.setAll(objects: users)
                completionHandler(
                    users.map({ (user) -> UserModel in
                        user.mapToBusiness()
                    })
                )
            })
        } else {
            do {
                try cache.getAll { (users) in
                    completionHandler(
                        users.map({ (user) -> UserModel in
                            user.mapToBusiness()
                        })
                    )
                }
            } catch {
                self.getAll(refresh: !refresh, completionHandler: completionHandler)
            }
        }
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
        if refresh {
            network.get(id: id, completionHandler: { (user) -> Void in
                self.cache.set(object: user)
                completionHandler(user?.mapToBusiness())
            })
        } else {
            do {
                try cache.get(id: id) { (user) in
                    completionHandler(user.mapToBusiness())
                }
            } catch {
               self.get(id: id, refresh: !refresh, completionHandler: completionHandler)
            }
        }
    }
    
    func getCurrent(refresh: Bool, completionHandler: @escaping (UserModel?, String?) -> Void) {
        if refresh {
            network.getCurrent(completionHandler: { (user, errorString) -> Void in
                guard let user = user else {
                    completionHandler(nil, errorString)
                    return
                }
                self.cache.set(object: user)
                completionHandler(user.mapToBusiness(), nil)
            })
        } else {
            
        }
    }
    
    func setAuthUser(userModel: UserModel) {
        self.cache.set(object: User.mapToEntity(model: userModel))
    }
    
    func searchForUsers(searchTerm: String, completionHandler: @escaping ([UserModel]) -> Void) {
        network.searchForUsers(searchTerm: searchTerm, completionHandler: { (users) -> Void in
            completionHandler(
                users.map({ (user) -> UserModel in
                    user.mapToBusiness()
                })
            )
        })
    }
    
}
