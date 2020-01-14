//
//  UserFollowRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserFollowRepositoryProtocol {
    
    /**
     Get a list of followers who are following the specific user.
     - parameter id: The id of the user.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: The callback will return a list of UserModels.
    */
    func getFollowers(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
    
    /**
     Get a list of the users which the specific user is following.
     - parameter id: The id of the user.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: The callback will return a list of UserModels.
     */
    func getFollowing(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
}
