//
//  RepositoryTermSearchProtocol.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol RepositorySearchTermProtocol: RepositoryProtocol {
    /**
     Get a list of models where a specific term is satisfied.
     - parameter term: The specific term the user need to contain.
     - parameter refresh: A boolean when false look in the cache first.
     - parameter completionHandler: A callback returning a list of models or nil.
     */
    func get(term: String, refresh: Bool, completionHandler: @escaping ([Model]) -> Void)
}
