//
//  UserUseCase.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserUseCase: RepositoryProtocol {
    typealias Model = UserModel
    
    static let shared = UserUseCase()
    
    private let repository = UserRepository.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([UserModel]?) -> Void) {
        repository.get(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
}
