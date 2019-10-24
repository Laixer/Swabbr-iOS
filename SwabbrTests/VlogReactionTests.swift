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
    
    var jsonString: String!
    var decoder: JSONDecoder!
    var encoder: JSONEncoder!

    override func setUp() {
        jsonString = "{\"id\": \"0\", \"private\": true, \"userId\": 2, \"duration\": \"00:20\", \"postDate\": \"2019-01-20 12:43\", \"vlogId\": \"2\"}"
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+0:00")
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
    }

    override func tearDown() {
        jsonString = nil
        decoder = nil
        encoder = nil
    }
    
    func testJSONToVlogReaction() {
        let jsonData = jsonString.data(using: .utf8)
        let vlogReaction = try? decoder.decode(VlogReaction.self, from: jsonData!)
        XCTAssertNotNil(vlogReaction, "The json string does not conform the VlogReaction model")
    }
    
    func testVlogReactionToJSON() {
        let jsonData = jsonString.data(using: .utf8)
        let originalJsonDict = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyHashable]
        
        let vlogReaction = try? decoder.decode(VlogReaction.self, from: jsonData!)
        let vlogReactionToJsonData = try? encoder.encode(vlogReaction)
        let vlogReactionToJsonDict = try? JSONSerialization.jsonObject(with: vlogReactionToJsonData!, options: []) as! [String: AnyHashable]
        
        XCTAssertEqual(originalJsonDict, vlogReactionToJsonDict, "The original json is not equal to the vlog reaction generated json: Original: \(originalJsonDict) | Generated: \(vlogReactionToJsonDict)")
    }

}
