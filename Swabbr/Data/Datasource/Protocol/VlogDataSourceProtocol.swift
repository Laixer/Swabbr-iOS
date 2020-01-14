//
//  VlogDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogDataSourceProtocol {
    typealias SetHandler = (Int) -> Void
    
    /**
     Get a specific vlog with id.
     - parameter id: The id of the vlog.
     - parameter completionHandler: A callback which will return an optional Vlog.
     */
    func get(id: String, completionHandler: @escaping (Vlog?) -> Void)
    
    /**
     Get the vlogs associated to a user.
     - parameter id: The id of the user.
     - parameter completionHandler: A callback which will return a list of Vlogs.
     */
    func getUserVlogs(id: String, completionHandler: @escaping ([Vlog]) -> Void)
    
    /**
     Get the featured vlogs.
     - parameter completionHandler: A callback which will return a list of Vlogs.
     */
    func getFeatured(completionHandler: @escaping ([Vlog]) -> Void)
    
    /**
     Give a like to a vlog.
     - parameter id: The id of the vlog.
     - parameter completionHandler: A callback which will return an optional String.
     */
    func createLike(id: String, completionHandler: @escaping SetHandler)
    
    /**
     Add a vlog to the remote.
     - parameter completionHandler: A callback which will return an optional String.
     */
    func createVlog(completionHandler: @escaping SetHandler)
}
