//
//  UserSettingsTests.swift
//  SwabbrTests
//
//  Created by James Bal on 14-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class UserSettingsTests: XCTestCase {
    
    private var userSettings: UserSettings!
    
    private class MockServer: UserSettingsDataSourceProtocol {
        
        private var userSettings: UserSettings!
        
        init(userSettings: UserSettings) {
            self.userSettings = userSettings
        }
        
        func get(completionHandler: @escaping (UserSettings?) -> Void) {
            do {
                let _ = try JSONEncoder().encode(userSettings)
                completionHandler(userSettings)
            } catch {
                completionHandler(nil)
            }
        }
        
        func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping (UserSettings?, String?) -> Void) {
            do {
                let _ = try JSONEncoder().encode(userSettings)
                completionHandler(userSettings, nil)
            } catch {
                completionHandler(nil, "Error")
            }
        }
        
    }
    
    private class MockCache: UserSettingsCacheDataSourceProtocol {
        
        var userSettings: UserSettings?
        
        func get(completionHandler: @escaping (UserSettings) -> Void) throws {
            guard let userSettings = userSettings else {
                throw NSError(domain: "cache", code: 404, userInfo: nil)
            }
            completionHandler(userSettings)
        }
        
        func set(object: UserSettings?) {
            guard let object = object else {
                return
            }
            userSettings = UserSettings(isPrivate: object.isPrivate,
                                        dailyVlogRequestLimit: object.dailyVlogRequestLimit,
                                        followMode: 999)
        }
        
        func remove() {
            guard userSettings != nil else {
                return
            }
            userSettings = nil
        }
        
    }

    override func setUp() {
        userSettings = UserSettings(isPrivate: true, dailyVlogRequestLimit: 10, followMode: 0)
    }
    
    override func tearDown() {
        userSettings = nil
    }
    
    func testDataSourceEntityToPresentationItem() {
        
        let userSettingsMockDS = MockServer(userSettings: userSettings)
        let userSettingsCacheDS = MockCache()
        let userSettingsRepository = UserSettingsRepository(network: userSettingsMockDS, userSettingsCache: userSettingsCacheDS)
        let userSettingsUseCase = UserSettingsUseCase(userSettingsRepository)
        
        userSettingsUseCase.get(refresh: false) { (userSettingsModel) in
            guard let userSettingsModel = userSettingsModel else {
                XCTFail("UserSettings object could not be converted to UsrSettingsModel")
                return
            }
            XCTAssertNotNil(UserSettingsItem.mapToPresentation(userSettingsModel: userSettingsModel), "The UserSettingsUseCase returns an incorrect Model which can't be converted to the item")
        }

    }

    func testIfCacheDataIsUsed() {

        let userSettingsMockDS = MockServer(userSettings: userSettings)
        let userSettingsCacheDS = MockCache()
        let userSettingsRepository = UserSettingsRepository(network: userSettingsMockDS, userSettingsCache: userSettingsCacheDS)
        let userSettingsUseCase = UserSettingsUseCase(userSettingsRepository)

        userSettingsUseCase.get(refresh: false) { (userSettingsModel) in
            
            guard let userSettingsModel = userSettingsModel else {
                XCTFail("UserSettings object could not be converted to UsrSettingsModel")
                return
            }

            XCTAssertEqual(userSettingsModel.followMode, self.userSettings.followMode)

            userSettingsUseCase.get(refresh: false) { (userSettingsModel) in

                XCTAssertEqual(userSettingsModel!.followMode, 999)

            }
        }

    }

    func testCacheThrowingErrorWhenUserNotFound() {
        let userSettingsCacheDS = MockCache()
        XCTAssertThrowsError(try userSettingsCacheDS.get() { (userSettings) in
            print(userSettings)
        })
    }
    
}
