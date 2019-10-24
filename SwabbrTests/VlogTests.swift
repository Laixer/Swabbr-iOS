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
    var encoder: JSONEncoder!

    override func setUp() {
        let jsonString = "{\"id\": \"0\", \"private\": true, \"userId\": 0, \"duration\": \"00:20\", \"startDate\": \"2019-02-02 13:45\", \"totalLikes\": 10, \"totalReactions\": 12, \"totalViews\": 10, \"isLive\": true}"
        jsonData = jsonString.data(using: .utf8)
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+0:00")
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
    }

    override func tearDown() {
        jsonData = nil
        decoder = nil
        encoder = nil
    }

    func testJSONToVlog() {
        let vlog = try? decoder.decode(Vlog.self, from: jsonData!)
        XCTAssertNotNil(vlog, "The json string does not conform the vlog model")
    }
    
    func testForCorrectDate() {
        let vlog = try? decoder.decode(Vlog.self, from: jsonData!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let expectedDate = dateFormatter.date(from: "2019-02-02 13:45")!
        XCTAssertEqual(vlog!.startDate, expectedDate, "The vlog start date: \(vlog!.startDate) is not the same as: \(expectedDate)")
    }
    
    func testVlogToJSON() {
        let vlog = try? decoder.decode(Vlog.self, from: jsonData!)
        let originalJsonDict = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyHashable]
        

        let vlogToJsonData = try? encoder.encode(vlog)
        let vlogToJsonDict = try? JSONSerialization.jsonObject(with: vlogToJsonData!, options: []) as! [String: AnyHashable]
        
        XCTAssertEqual(originalJsonDict, vlogToJsonDict, "The original json is not equal to the vlog generated json: Original: \(originalJsonDict) | Generated: \(vlogToJsonDict)")
    }

}
