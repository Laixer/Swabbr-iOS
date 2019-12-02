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
        jsonString = "{\"protocol\":\"swabbr\",\"protocol_version\":1,\"data_type\":\"notification\",\"data_type_version\":1,\"data\":{\"title\":\"vlog\",\"message\":\"Opnemen\",\"click_action\":\"vlog_record_request\"},\"content_type\":\"json\",\"timestamp\":\"\",\"user_agent\":\"iphone\"}"
        jsonData = jsonString.data(using: .utf8)
        decoder = JSONDecoder()
    }

    override func tearDown() {
        jsonString = nil
        jsonData = nil
        decoder = nil
    }

    func testJSONToNotification() {
        let notification = try? decoder.decode(Payload<SNotification>.self, from: jsonData!)
        XCTAssertNotNil(notification, "The notification model does not conform the payload model")
    }
    
    func testTheNotificationData() {
        let notification = try? decoder.decode(Payload<SNotification>.self, from: jsonData!)
        XCTAssertEqual(notification!.innerData.clickAction, SNotification.ClickAction.vlogRecordRequest, "The notification click action: \(notification!.innerData.clickAction), is not the same as expected: \(SNotification.ClickAction.vlogRecordRequest)")
    }

}
