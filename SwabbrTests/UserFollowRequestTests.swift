//
//  UserFollowRequestTests.swift
//  SwabbrTests
//
//  Created by James Bal on 22-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class UserFollowRequestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSONToUserFollowRequest() {
        let jsonString = "{\"id\": \"0\", \"requesterId\": \"1\", \"receiverId\": \"2\", \"status\": \"accepted\", \"timestamp\": \"2019-01-20 12:43\"}"
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        let userFollowRequest = try? decoder.decode(UserFollowRequest.self, from: jsonData!)
        XCTAssertNotNil(userFollowRequest, "The json string does not conform the UserFollowRequest model")
        XCTAssert(userFollowRequest!.status == UserFollowRequest.Status.Accepted, "The current status is not as expected")
    }

}
