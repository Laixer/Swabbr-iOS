//
//  VlogRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogRepositoryProtocol {
    typealias SetHandler = (Int) -> Void
    
    /**
     Get a specific vlog with id.
     - parameter id: The id of the vlog.
     - parameter refresh: When true retrieve data from remote.
     - parameter completionHandler: A callback which will return an optional VlogModel.
    */
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void)
    
    /**
     Get the vlogs associated to a user.
     - parameter id: The id of the user.
     - parameter refresh: When true retrieve data from remote.
     - parameter completionHandler: A callback which will return a list of VlogModels.
    */
    func getUserVlogs(id: String, refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void)
    
    /**
     Get the featured vlogs.
     - parameter refresh: When true retrieve data from remote.
     - parameter completionHandler: A callback which will return a list of VlogModels.
    */
    func getFeatured(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void)
    
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
