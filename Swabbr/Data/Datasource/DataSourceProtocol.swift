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
    Get all entities.
    - parameter completionHandler: A callback returning a list of entities or nil.
    */
    func get(completionHandler: @escaping ([Entity]) -> Void)
    /**
     Get a specifc entity by a certain id.
     - parameter id: An int value of an specific id.
     - parameter completionHandler: A callback returning the entity or nil.
     */
    func get(id: Int, completionHandler: @escaping (Entity?) -> Void)
}

protocol DataSourceMultipleProtocol: DataSourceProtocol {
    /**
     Get specific entities by a certain id.
     - parameter id: An int value of an specific id.
     - parameter completionHandler: A callback returning a list of entities or nil.
     */
    func get(id: Int, multiple completionHandler: @escaping ([Entity]?) -> Void)
}
