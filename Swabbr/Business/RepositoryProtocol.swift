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
     Get all models.
     - parameter refresh: A boolean which indicates if it should look in the cache first.
     - parameter completionHandler: A callback returning a list of models or nil.
    */
    func get(refresh: Bool, completionHandler: @escaping ([Model]?) -> Void)
    
    /**
     Get a specifc model by a certain id.
     - parameter id: An int value of an specific id.
     - parameter refresh: A boolean when false look in the cache first.
     - parameter completionHandler: A callback returning the model or nil.
     */
    func get(id: Int, refresh: Bool, completionHandler: @escaping (Model?) -> Void)
}

protocol RepositoryMultipleProtocol: RepositoryProtocol {
    /**
     Get specific models by a certain id.
     - parameter id: An int value of an specific id.
     - parameter refresh: A boolean when false look in the cache first.
     - parameter completionHandler: A callback returning a list of models or nil.
     */
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([Model]?) -> Void)
}
