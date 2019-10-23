//
//  VlogReactionTests.swift
//  SwabbrTests
//
//  Created by James Bal on 22-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class VlogReactionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testJSONToVlogReaction() {
        let jsonString = "{\"id\": \"0\", \"isPrivate\": true, \"ownerId\": 2, \"duration\": \"00:20\", \"postDate\": \"2019-01-20 12:43\", \"vlogId\": \"2\"}"
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        let vlogReaction = try? decoder.decode(VlogReaction.self, from: jsonData!)
        XCTAssertNotNil(vlogReaction, "The json string does not conform the VlogReaction model")
    }

}
