//
//  AuthTests.swift
//  SwabbrTests
//
//  Created by James Bal on 18-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class AuthTests: XCTestCase {
    
    private var registrationUserItem: RegistrationUserItem!
    private var loginUserItem: LoginUserItem!
    
    private class AuthMockServer: AuthDataSourceProtocol {
        
        var user = User(id: "1",
                        firstName: "Test",
                        lastName: "Test",
                        gender: 0,
                        country: "Test",
                        email: "test@test.test",
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
        
        let userSettings = UserSettings(isPrivate: true,
                                        dailyVlogRequestLimit: 1,
                                        followMode: 1)
        
        func login(loginUser: LoginUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void) {
            if loginUser.email == user.email {
                user.id = "2"
                do {
                    let _ = try JSONEncoder().encode(loginUser)
                    completionHandler(AuthorizedUser(accessToken: "1234", user: user, userSettings: userSettings), nil)
                } catch {
                    completionHandler(nil, "Error")
                }
            } else {
                completionHandler(nil, "Error")
            }
        }
        
        func register(registrationUser: RegistrationUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void) {
            if registrationUser.email == user.email {
                user.id = "2"
                do {
                    let _ = try JSONEncoder().encode(registrationUser)
                    completionHandler(AuthorizedUser(accessToken: "1234", user: user, userSettings: userSettings), nil)
                } catch {
                    completionHandler(nil, "Error")
                }
            } else {
                completionHandler(nil, "Error")
            }
        }
        
        func logout(completionHandler: @escaping (String?) -> Void) {
            return completionHandler(nil)
        }
        
    }

    override func setUp() {
        
        registrationUserItem = RegistrationUserItem(firstName: "Test",
                                                    lastName: "Test",
                                                    gender: 1,
                                                    country: "",
                                                    email: "test@test.test",
                                                    password: "",
                                                    birthdate: Date(),
                                                    timezone: "",
                                                    username: "",
                                                    profileImageUrl: "",
                                                    isPrivate: true,
                                                    phoneNumber: "")
        
        loginUserItem = LoginUserItem(email: "test@test.test",
                                      password: "",
                                      rememberMe: true)
        
    }

    override func tearDown() {
        
        registrationUserItem = nil
        loginUserItem = nil
        
    }
    
    func testLoginSuccess() {
        let authMockDS = AuthMockServer()
        let authRepository = AuthRepository(network: authMockDS)
        authRepository.login(loginUser: loginUserItem.mapToBusiness()) { (model, error)  in
            
            guard let model = model else {
                XCTFail("Failed creating a AuthorizedUser with given error: \(String(describing: error))")
                return
            }
            
            XCTAssertEqual(model.user.id, "2")
        }
    }
    
    func testLoginFail() {
        let authMockDS = AuthMockServer()
        let authRepository = AuthRepository(network: authMockDS)
        loginUserItem.email = "test"
        authRepository.login(loginUser: loginUserItem.mapToBusiness()) { (model, error) in
            
            guard let error = error else {
                XCTFail("There is no error")
                return
            }
            
            XCTAssertNotNil(error, "We didn't receive an error as expected")
        }
    }
    
    func testRegisterSuccess() {

        let authMockDS = AuthMockServer()
        let authRepository = AuthRepository(network: authMockDS)
        authRepository.register(registerUser: registrationUserItem.mapToBusiness()) { (model, error) in
            
            guard let model = model else {
                XCTFail("Failed creating a AuthorizedUser with given error: \(String(describing: error))")
                return
            }
            
            XCTAssertEqual(model.user.id, "2")
        }
    }
    
    func testRegisterFail() {
        let authMockDS = AuthMockServer()
        let authRepository = AuthRepository(network: authMockDS)
        registrationUserItem.email = "test"
        authRepository.register(registerUser: registrationUserItem.mapToBusiness()) { (model, error) in
            
            guard let error = error else {
                XCTFail("There is no error")
                return
            }
            
            XCTAssertNotNil(error, "We didn't receive an error as expected")
            
        }
    }

}
