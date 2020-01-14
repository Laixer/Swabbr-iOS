//
//  UserFollowRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserFollowRepositoryProtocol {
    func getFollowers(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
    func getFollowing(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
}
