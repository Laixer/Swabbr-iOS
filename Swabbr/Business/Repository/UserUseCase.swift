//
//  UserUseCase.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(_ repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }

    func get(refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void) {
        repository.getAll(refresh: refresh, completionHandler: completionHandler)
    }

    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
}
