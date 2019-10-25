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
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let testDate = dateFormatter.date(from: "2002/12/23 12:32")
        var localeDate = DateFormatter().displayDateAsString(date: testDate!, localeId: "nl_NL", timeZoneMock: TimeZone.init(abbreviation: "CEST")!)
        var dateExpected = (TimeZone.init(abbreviation: "CEST")!.daylightSavingTimeOffset() > 0) ? "23-12-2002 14:32" : "23-12-2002 13:32"
        XCTAssertEqual(localeDate, dateExpected, "The date: \(localeDate) is not the same as expected: \(dateExpected)")
        
        localeDate = DateFormatter().displayDateAsString(date: testDate!, localeId: "ja_JP", timeZoneMock: TimeZone.init(abbreviation: "JST")!)
        dateExpected = "2002/12/23 21:32"
        XCTAssertEqual(localeDate, dateExpected, "The date: \(localeDate) is not the same as expected: \(dateExpected)")
        
        localeDate = DateFormatter().displayDateAsString(date: testDate!, localeId: "en_US", timeZoneMock: TimeZone.init(abbreviation: "PST")!)
        dateExpected = "12/23/2002, 05:32"
        XCTAssertEqual(localeDate, dateExpected, "The date: \(localeDate) is not the same as expected: \(dateExpected)")
    }

}
