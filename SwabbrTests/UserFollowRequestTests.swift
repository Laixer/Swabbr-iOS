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
    
    var jsonString: String!
    var jsonData: Data!
    var decoder: JSONDecoder!
    var encoder: JSONEncoder!

    override func setUp() {
        jsonString = "{\"id\": \"0\", \"requesterId\": \"1\", \"receiverId\": \"2\", \"status\": \"accepted\", \"timestamp\": \"2019-01-20 12:43\"}"
        jsonData = jsonString.data(using: .utf8)
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+0:00")
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
    }

    override func tearDown() {
        jsonString = nil
        jsonData = nil
        decoder = nil
        encoder = nil
    }

    func testJSONToUserFollowRequest() {
        let userFollowRequest = try? decoder.decode(UserFollowRequest.self, from: jsonData!)
        XCTAssertNotNil(userFollowRequest, "The json string does not conform the UserFollowRequest model")
        XCTAssert(userFollowRequest!.status == UserFollowRequest.Status.Accepted, "The current status is not as expected")
    }
    
    func testUserFollowRequestToJSON() {
        let userFollowRequest = try? decoder.decode(UserFollowRequest.self, from: jsonData!)
        let originalJsonDict = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyHashable]
        
        let userFollowRequestToJsonData = try? encoder.encode(userFollowRequest)
        let userFollowRequestToJsonDict = try? JSONSerialization.jsonObject(with: userFollowRequestToJsonData!, options: []) as! [String: AnyHashable]
        
        XCTAssertEqual(originalJsonDict, userFollowRequestToJsonDict, "The original json is not equal to the user follow request generated json: Original: \(originalJsonDict) | Generated: \(userFollowRequestToJsonDict)")
    }

}
