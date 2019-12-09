//
//  RepositorySingleMultipleProtocol.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol RepositorySingleMultipleProtocol: RepositoryProtocol {
    /**
     Get specific models by a certain id.
     - parameter id: An int value of an specific id.
     - parameter refresh: A boolean when false look in the cache first.
     - parameter completionHandler: A callback returning a list of models or nil.
     */
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([Model]) -> Void)
}
