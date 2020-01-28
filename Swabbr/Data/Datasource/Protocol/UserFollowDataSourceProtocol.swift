//
//  UserFollowDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserFollowDataSourceProtocol {
    
    /**
     Get a list of followers who are following the specific user.
     - parameter id: The id of the user.
     - parameter completionHandler: The callback will return a list of User.
     */
    func getFollowers(id: String, completionHandler: @escaping ([User]) -> Void)
    
    /**
     Get a list of the users which the specific user is following.
     - parameter id: The id of the user.
     - parameter completionHandler: The callback will return a list of User.
     */
    func getFollowing(id: String, completionHandler: @escaping ([User]) -> Void)
    
    func unfollowUser(userId: String, completionHandler: @escaping (String?) -> Void)
}
