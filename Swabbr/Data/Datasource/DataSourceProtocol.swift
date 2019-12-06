//
//  DataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol DataSourceProtocol {
    associatedtype Entity: Decodable
    /**
     Get a specifc entity by a certain id.
     - parameter id: An int value of an specific id.
     - parameter completionHandler: A callback returning the entity or nil.
     */
    func get(id: Int, completionHandler: @escaping (Entity?) -> Void)
}
