//
//  UserTests.swift
//  SwabbrTests
//
//  Created by James Bal on 09-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class UserTests: XCTestCase {
    
    private var user: User!
    
    private class MockUserDataSource: UserDataSourceProtocol {
        func searchForUsers(searchTerm: String, completionHandler: @escaping ([User]) -> Void) {
            completionHandler([])
        }

        private let user: User
        
        init(user: User) {
            self.user = user
        }
        
        func get(id: String, completionHandler: @escaping (User?) -> Void) {
            do {
                let _ = try JSONEncoder().encode(user)
                completionHandler(user)
            } catch {
                completionHandler(nil)
            }
        }
        
        func getAll(completionHandler: @escaping ([User]) -> Void) {
            completionHandler([user])
        }
        
        func getCurrent(completionHandler: @escaping (User?, String?) -> Void) {
            do {
                let _ = try JSONEncoder().encode(user)
                completionHandler(user, nil)
            } catch {
                completionHandler(nil, "Error")
            }
        }
    }
    
    private class MockUserCache: UserCacheDataSourceProtocol {
        
        private var user: User?
        
        func get(id: String, completionHandler: @escaping (User) -> Void) throws {
            guard let user = user else {
                throw NSError(domain: "cache", code: 404, userInfo: nil)
            }
            completionHandler(user)
        }
        
        func set(object: User?) {
            guard var object = object else {
                return
            }
            object.id = "2"
            user = object
        }
        
        func getAll(completionHandler: @escaping ([User]) -> Void) throws {
            guard let user = user else {
                throw NSError(domain: "cache", code: 404, userInfo: nil)
            }
            completionHandler([user])
        }
        
        func setAll(objects: [User]) {
            user = objects[0]
            user!.id = "2"
        }
    }

    override func setUp() {
        
        user = User(id: "1",
                    firstName: "Test",
                    lastName: "Test",
                    gender: 0,
                    country: "Test",
                    email: "Test@Test.nl",
                    birthdate: "02/06/2019",
                    timezone: "CET",
                    username: "Test",
                    profileImageUrl: "Test",
                    totalVlogs: 1,
                    totalFollowers: 1,
                    totalFollowing: 1,
                    longitude: 15.05,
                    latitude: 15.05,
                    isPrivate: true)
        
    }

    override func tearDown() {
        user = nil
    }
    
    func testDataSourceEntityToPresentationItem() {
        
        let userMockDS = MockUserDataSource(user: user)
        let userRepository = UserRepository(network: userMockDS)
        let userUseCase = UserUseCase(userRepository)
        
        userUseCase.get(id: "1", refresh: true) { (userModel) in
            guard let userModel = userModel else {
                XCTFail("The user object could not be converted to model")
                return
            }
            XCTAssertNotNil(UserItem.mapToPresentation(model: userModel), "The UserUseCase returns an incorrect Model which can't be converted to the item")
        }
        
    }
    
    func testIfCacheDataIsUsed() {
        
        let userMockCache = MockUserCache()
        let userMockDS = MockUserDataSource(user: user)
        let userRepository = UserRepository(network: userMockDS, cache: userMockCache)
        let userUseCase = UserUseCase(userRepository)
        
        userUseCase.get(id: "1", refresh: false) { (userModel) in
            
            guard let userModel = userModel else {
                XCTFail("The user object could not be converted to model")
                return
            }
            
            XCTAssertEqual(userModel.id, self.user.id)
            
            userUseCase.get(id: "1", refresh: false) { (userModel) in
                
                XCTAssertEqual(userModel!.id, "2")
                
            }
        }
        
    }
    
    func testCacheThrowingErrorWhenUserNotFound() {
        let userMockCache = MockUserCache()
        XCTAssertThrowsError(try userMockCache.get(id: "11111") { (user) in
            print(user)
        })
    }
    
}
