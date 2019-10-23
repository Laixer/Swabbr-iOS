//
//  VlogTests.swift
//  SwabbrTests
//
//  Created by James Bal on 14-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class VlogTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSONToVlog() {
        let jsonString = "[{\"id\": \"0\", \"private\": true, \"userId\": 0, \"duration\": \"00:20\", \"startDate\": \"2019-02-02 13:45\", \"totalLikes\": 10, \"totalReactions\": 12, \"totalViews\": 10, \"isLive\": true}]"
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        let vlogs = try? decoder.decode([Vlog].self, from: jsonData!)
        XCTAssertNotNil(vlogs![0], "The json string does not conform the vlog model")
    }

}
