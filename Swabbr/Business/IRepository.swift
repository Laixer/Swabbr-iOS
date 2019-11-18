//
//  IRepository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol IRepository {
    associatedtype Model
    func get(refresh: Bool, completionHandler: @escaping ([Model]?) -> Void)
    func get(id: Int, refresh: Bool, completionHandler: @escaping (Model?) -> Void)
}
