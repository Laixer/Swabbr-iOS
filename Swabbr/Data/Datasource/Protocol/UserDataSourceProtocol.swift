//
//  UserDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (User?) -> Void)
    func getAll(completionHandler: @escaping ([User]) -> Void)
}
