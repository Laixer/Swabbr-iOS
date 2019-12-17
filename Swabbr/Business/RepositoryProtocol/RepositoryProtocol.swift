//
//  RepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// MARK: UserRepositoryProtocol
protocol UserRepositoryProtocol {
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserModel?) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
}

// MARK: VlogRepositoryProtocol
protocol VlogRepositoryProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void)
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void)
    func createLike(id: String, completionHandler: @escaping SetHandler)
    func createVlog(completionHandler: @escaping SetHandler)
}

// MARK: VlogReactionRepositoryProtocol
protocol VlogReactionRepositoryProtocol {
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void)
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void)
}

// MARK: FollowRepositoryProtocol
protocol FollowRequestRepositoryProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void)
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    func createFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func destroyFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func acceptFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
    func declineFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
}

// MARK: UserFollowRepositoryProtocol
protocol UserFollowRepositoryProtocol {
    func getFollowers(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
    func getFollowing(id: String, refresh: Bool, completionHandler: @escaping ([UserModel]) -> Void)
    func get(id: String, refresh: Bool, completionHandler: @escaping (FollowStatusModel?) -> Void)
}

// MARK: UserSettingsRepositoryProtocol
protocol UserSettingsRepositoryProtocol {
    typealias SetHandler = (Int) -> Void
    func get(refresh: Bool, completionHandler: @escaping (UserSettingsModel?) -> Void)
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping SetHandler)
}

// MARK: LoginRepositoryProtocol
protocol LoginRepositoryProtocol {
    func login(loginUser: LoginUserModel, completionHandler: @escaping (Int) -> Void)
}

// MARK: RegisterRepositoryProtocol
protocol RegisterRepositoryProtocol {
    func register(registerUser: RegistrationUserModel, completionHandler: @escaping (Int) -> Void)
}



