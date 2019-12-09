//
//  UserFollowingRepository.swift
//  Swabbr
//
//  Created by James Bal on 05-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserFollowingRepository: RepositorySingleMultipleProtocol {
    
    typealias Model = UserModel
    
    private let network: DataSourceFactory<User>
    
    init(network: DataSourceFactory<User> = DataSourceFactory(UserFollowingNetwork.shared)) {
        self.network = network
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
        network.get(id: id, completionHandler: { (user) in
            completionHandler(user?.mapToBusiness())
        })
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        network.getSingleMultiple(id: id) { (users) in
            guard let users = users else {
                completionHandler([])
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
