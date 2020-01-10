//
//  UserRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserRepositoryProtocol {
    /**
     Get a certain user.
     - parameter id: The id of the user.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: This will return a optional UserModel value.
     */
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void)
    
    /**
     Get all users.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: This will return a list of UserModel.
     */
    func getAll(refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
    
    /**
     Get the current logged in user.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: This will return an optional UserModel and an optional String.
    */
    func getCurrent(refresh: Bool, completionHandler: @escaping (UserModel?, String?) -> Void)
    
    /**
     Save current user in the cache.
     - parameter userModel: An userModel.
    */
    func setAuthUser(userModel: UserModel)
    
    /**
     Search for users with a specific search term.
     - parameter searchTerm: The searchter which will be used to identify the correct users.
     - parameter completionHandler: This will return a list of usermodel items.
    */
    func searchForUsers(searchTerm: String, completionHandler: @escaping ([UserModel]) -> Void)
}
