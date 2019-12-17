//
//  CacheDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol CacheDataSourceProtocol {
    associatedtype Entity: Decodable
    func get(id: String, completionHandler: @escaping (Entity) -> Void) throws
    func set(object: Entity?)
}
