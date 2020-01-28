//
//  NotificationTests.swift
//  SwabbrTests
//
//  Created by James Bal on 21-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class NotificationTests: XCTestCase {
    
    var jsonString: String!
    var jsonData: Data!
    var decoder: JSONDecoder!

    override func setUp() {
        jsonString = "{\"protocol\":\"swabbr\",\"protocol_version\":1,\"data_type\":\"notification\",\"data_type_version\":1,\"data\":{\"click_action\":\"vlog_record_request\", \"object\":{\"Id\":\"test\",\"HostAddress\":\"Opnemen\",\"AppName\":\"test\", \"Password\": \"test\", \"Port\": 532, \"StreamName\": \"test\", \"Username\": \"test\"}},\"content_type\":\"json\",\"timestamp\":\"5435345\",\"user_agent\":\"iphone\"}"
        jsonData = jsonString.data(using: .utf8)
        decoder = JSONDecoder()
    }

    override func tearDown() {
        jsonString = nil
        jsonData = nil
        decoder = nil
    }

    func testJSONToNotification() {
        do {
            let notification = try decoder.decode(Payload<SNotification>.self, from: jsonData!)
            print("done")
            XCTAssertNotNil(notification, "Could not decode")
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTheNotificationData() {
        let notification = try? decoder.decode(Payload<SNotification>.self, from: jsonData!)
        XCTAssertEqual(notification!.innerData.clickAction, SNotification.ClickAction.vlogRecordRequest, "The notification click action: \(notification!.innerData.clickAction), is not the same as expected: \(SNotification.ClickAction.vlogRecordRequest)")
    }

}
