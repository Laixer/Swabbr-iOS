//
//  SwabbrUITests.swift
//  SwabbrUITests
//
//  Created by James Bal on 11-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest

class SwabbrUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments.append("testing")
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        app = nil
    }

    func testCurrentUserProfileWithUpdateButton() {
        
        // get profile image
        let image = app.otherElements.containing(.navigationBar, identifier:"Timeline").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element
        image.tap()
        
        // check if button with "Update" exists
        XCTAssertNotNil(app.buttons["Update"])
        
    }

    func testOtherUserProfileWithFollowButton() {
        // simulate swipe to other vlog
        app.swipeRight()
        
        // get profile image
        let image = app.otherElements.containing(.navigationBar, identifier:"Timeline").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element
        image.tap()
        
        // check if button with "Follow" exists
        XCTAssertNotNil(app.buttons["Follow"])
    }

}
