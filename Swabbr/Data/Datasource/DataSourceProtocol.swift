//
//  DataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// MARK: UserDataSourceProtocol
protocol UserDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (User?) -> Void)
    func getAll(completionHandler: @escaping ([User]) -> Void)
}

// MARK: VlogDataSourceProtocol
protocol VlogDataSourceProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, completionHandler: @escaping (Vlog?) -> Void)
    func getSingleMultiple(id: String, completionHandler: @escaping ([Vlog]) -> Void)
    func getAll(completionHandler: @escaping ([Vlog]) -> Void)
    func createLike(id: String, completionHandler: @escaping SetHandler)
    func createVlog(completionHandler: @escaping SetHandler)
}

// MARK: VlogReactionDataSourceProtocol
protocol VlogReactionDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (VlogReaction?) -> Void)
    func getSingleMultiple(id: String, completionHandler: @escaping ([VlogReaction]) -> Void)
    func getAll(completionHandler: @escaping ([VlogReaction]) -> Void)
}

protocol FollowRequestDataSourceProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, completionHandler: @escaping (UserFollowRequest?) -> Void)
    func getSingleMultiple(id: String, completionHandler: @escaping ([UserFollowRequest]) -> Void)
    func getAll(completionHandler: @escaping ([UserFollowRequest]) -> Void)
    func createFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func destroyFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func acceptFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
    func declineFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
}

// MARK: UserFollowRepositoryProtocol
protocol UserFollowDataSourceProtocol {
    func getFollowers(id: String, completionHandler: @escaping ([User]) -> Void)
    func getFollowing(id: String, completionHandler: @escaping ([User]) -> Void)
    func get(id: String, completionHandler: @escaping (FollowStatus?) -> Void)
}

// MARK: UserSettingsDataSourceProtocol
protocol UserSettingsDataSourceProtocol {
    typealias SetHandler = (Int) -> Void
    func get(completionHandler: @escaping (UserSettings?) -> Void)
    func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping SetHandler)
}

// MARK: AuthDataSourceProtocol
protocol AuthDataSourceProtocol {
    func login(loginUser: LoginUser, completionHandler: @escaping (Int, String, User, UserSettings) -> Void)
    func register(registrationUser: RegistrationUser, completionHandler: @escaping (Int, String, User, UserSettings) -> Void)
}
