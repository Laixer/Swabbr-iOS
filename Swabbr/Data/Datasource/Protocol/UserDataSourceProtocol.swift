//
//  UserDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserDataSourceProtocol {
    /**
     Get a certain user.
     - parameter id: The id of the user.
     - parameter completionHandler: This will return a optional User value.
    */
    func get(id: String, completionHandler: @escaping (User?) -> Void)
    
    /**
     Get all users.
     - parameter completionHandler: This will return a list of users
    */
    func getAll(completionHandler: @escaping ([User]) -> Void)
    
    /**
     Get the current logged in user.
     - parameter completionHandler: This will return an optional User and a optional String.
    */
    func getCurrent(completionHandler: @escaping (User?, String?) -> Void)
    
    /**
     Search for a specific user.
     - parameter searchTerm: The term which will be used to identify the users.
     - parameter completionHandler: This will return a list of users.
    */
    func searchForUsers(searchTerm: String, completionHandler: @escaping ([User]) -> Void)
}
