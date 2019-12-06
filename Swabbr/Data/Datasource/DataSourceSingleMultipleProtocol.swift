//
//  DataSourceMultipleProtocol.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol DataSourceSingleMultipleProtocol: DataSourceProtocol {
    /**
     Get specific entities by a certain id.
     - parameter id: An int value of an specific id.
     - parameter completionHandler: A callback returning a list of entities or nil.
     */
    func getSingleMultiple(id: Int, completionHandler: @escaping ([Entity]?) -> Void)
}
