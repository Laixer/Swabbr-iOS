//
//  RepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol RepositoryProtocol {
    associatedtype Model
    
    /**
     Get a specifc model by a certain id.
     - parameter id: An int value of an specific id.
     - parameter refresh: A boolean when false look in the cache first.
     - parameter completionHandler: A callback returning the model or nil.
     */
    func get(id: Int, refresh: Bool, completionHandler: @escaping (Model?) -> Void)
}
