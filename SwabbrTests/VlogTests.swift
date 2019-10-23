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
    
    var jsonData: Data!
    var decoder: JSONDecoder!

    override func setUp() {
        let jsonString = "{\"id\": \"0\", \"private\": true, \"userId\": 0, \"duration\": \"00:20\", \"startDate\": \"2019-02-02 13:45\", \"totalLikes\": 10, \"totalReactions\": 12, \"totalViews\": 10, \"isLive\": true}"
        jsonData = jsonString.data(using: .utf8)
        decoder = JSONDecoder()
    }

    override func tearDown() {
        jsonData = nil
        decoder = nil
    }

    func testJSONToVlog() {
        let vlog = try? decoder.decode(Vlog.self, from: jsonData!)
        XCTAssertNotNil(vlog, "The json string does not conform the vlog model")
    }
    
    func testForCorrectDate() {
        let vlog = try? decoder.decode(Vlog.self, from: jsonData!)
        XCTAssert(vlog!.startDate.iso8601() == "2019-02-02T13:45:00.000Z", "The vlog start date: \(vlog!.startDate.iso8601()) is not the same as: 2019-02-02T13:45:00.000Z")
    }

}
