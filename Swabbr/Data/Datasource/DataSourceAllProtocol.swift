//
//  DataSourceAllProtocol.swift
//  Swabbr
//
//  Created by James Bal on 06-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol DataSourceAllProtocol: DataSourceProtocol {
    /**
     Get all entities.
     - parameter completionHandler: A callback returning a list of entities or nil.
     */
    func getAll(completionHandler: @escaping ([Entity]?) -> Void)
}
