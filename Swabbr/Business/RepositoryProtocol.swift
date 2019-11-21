//
//  RepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol RepositoryProtocol {
    associatedtype Model
    func get(refresh: Bool, completionHandler: @escaping ([Model]?) -> Void)
    func get(id: Int, refresh: Bool, completionHandler: @escaping (Model?) -> Void)
}

protocol RepositoryMultipleProtocol: RepositoryProtocol {
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([Model]?) -> Void)
}
