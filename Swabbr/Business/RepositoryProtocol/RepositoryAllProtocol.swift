//
//  RepositoryAllProtocol.swift
//  Swabbr
//
//  Created by James Bal on 06-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol RepositoryAllProtocol: RepositoryProtocol {
    /**
     Get all models.
     - parameter refresh: A boolean which indicates if it should look in the cache first.
     - parameter completionHandler: A callback returning a list of models or nil.
     */
    func getAll(refresh: Bool, completionHandler: @escaping ([Model]) -> Void)
}
