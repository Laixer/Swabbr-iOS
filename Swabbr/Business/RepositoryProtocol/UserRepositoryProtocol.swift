//
//  UserRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserRepositoryProtocol {
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
}
