//
//  DataSourceSearchTermProtocol.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol DataSourceSearchTermProtocol: DataSourceProtocol {
    /**
     Get a list of entities that complies to the search term.
     - parameter term: A string value which represents the search term.
     - parameter completionhandler: A callback returning a list of entities or nil.
     */
    func get(term: String, completionHandler: @escaping ([Entity]?) -> Void)
}
