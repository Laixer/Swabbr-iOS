//
//  DateTests.swift
//  SwabbrTests
//
//  Created by James Bal on 25-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class DateTests: XCTestCase {
    
    var dateFormatter: DateFormatter!

    override func setUp() {
        dateFormatter = DateFormatter()
    }

    override func tearDown() {
        dateFormatter = nil
    }

    func testDisplayOfDate() {
        let testDate = dateFormatter.stringToBaseDate(format: "yyyy/MM/dd HH:mm", value: "2002/12/23 12:32")
        var localeDate = dateFormatter.displayDateAsString(date: testDate!, localeId: "nl_NL", timeZoneId: "Europe/Amsterdam")
        var dateExpected = (TimeZone.init(identifier: "Europe/Amsterdam")!.isDaylightSavingTime()) ? "23-12-2002 14:32" : "23-12-2002 13:32"

        XCTAssertEqual(localeDate, dateExpected, "The date: \(localeDate) is not the same as expected: \(dateExpected)")
        
        localeDate = DateFormatter().displayDateAsString(date: testDate!, localeId: "ja_JP", timeZoneId: "Asia/Tokyo")
        dateExpected = "2002/12/23 21:32"
        XCTAssertEqual(localeDate, dateExpected, "The date: \(localeDate) is not the same as expected: \(dateExpected)")
        
        localeDate = DateFormatter().displayDateAsString(date: testDate!, localeId: "en_US", timeZoneId: "America/Los_Angeles")
        dateExpected = (TimeZone.init(identifier: "America/Los_Angeles")!.isDaylightSavingTime()) ? "12/23/2002, 05:32" : "12/23/2002, 04:32"
        XCTAssertEqual(localeDate, dateExpected, "The date: \(localeDate) is not the same as expected: \(dateExpected)")
    }

}
