//
//  UserTests.swift
//  SwabbrTests
//
//  Created by James Bal on 09-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class UserTests: XCTestCase {
    
    var jsonString: String!
    var decoder: JSONDecoder!
    var encoder: JSONEncoder!

    override func setUp() {
        
        jsonString = "{\"id\": \"0\", \"firstName\": \"Apple\", \"lastName\": \"Swift\", \"gender\": \"M\", \"country\": \"Germany\", \"email\": \"apple@swift.com\", \"birthdate\": \"02/06/2014\", \"timezone\": \"+2\", \"nickname\": \"AppleIsTheBest\", \"profileImageUrl\": \"image.png\", \"interests\": [\"Apple\", \"Swift\", \"Innovation\"], \"totalVlogs\": 2, \"totalFollowers\":6, \"totalFollowing\": 2014, \"longitude\": \"0.0\", \"latitude\": \"0.0\"}"
        decoder = JSONDecoder()
        
        encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+0:00")
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
    }

    override func tearDown() {
        
        jsonString = nil
        decoder = nil
        encoder = nil
        
    }

    func testJSONToUser() {
        let jsonData = jsonString.data(using: .utf8)
        let user = try? decoder.decode(User.self, from: jsonData!)
        XCTAssertNotNil(user, "The json string does not conform the user model")
    }
    
    func testErrorMessageWhenConvertToFloatFails() {
        jsonString = "{\"id\": \"0\", \"firstName\": \"Apple\", \"lastName\": \"Swift\", \"gender\": \"M\", \"country\": \"Germany\", \"email\": \"apple@swift.com\", \"birthdate\": \"02/06/2014\", \"timezone\": \"+2\", \"nickname\": \"AppleIsTheBest\", \"profileImageUrl\": \"image.png\", \"interests\": [\"Apple\", \"Swift\", \"Innovation\"], \"totalVlogs\": 2, \"totalFollowers\":6, \"totalFollowing\": 2014, \"longitude\": \"53.00003\", \"latitude\": \"Test\"}"
        let jsonData = jsonString.data(using: .utf8)
        XCTAssertThrowsError(try decoder.decode(User.self, from: jsonData!)) { (error) in
            print(error)
        }
        
    }
    
    func testForCorrectDate() {
        let jsonData = jsonString.data(using: .utf8)
        let user = try? decoder.decode(User.self, from: jsonData!)
        
        let expectedDateString = "2014-06-02T00:00:00.000Z"

        XCTAssertEqual(user!.birthdate.iso8601(), expectedDateString, "The user birthdate: \(user!.birthdate.iso8601()) is not the same as: \(expectedDateString)")
    }
    
    func testUserToJSON() {
        
        let jsonData = jsonString.data(using: .utf8)
        let userObject = try? decoder.decode(User.self, from: jsonData!)
        
        let userJsonBytes = try? encoder.encode(userObject)
        let userJson = try? JSONSerialization.jsonObject(with: userJsonBytes!, options: []) as! [String: AnyHashable]
        
        let originalJson = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyHashable]

        XCTAssertEqual(originalJson, userJson, "The original json is not equal to the user generated json: Original: \(originalJson) | Generated: \(userJson)")
        
    }
    
    func testPayloadWithUserObject() {
        
        let payloadString = "{\"protocol\":\"swabbr\",\"protocol_version\":1,\"data_type\":\"notification\",\"data_type_version\":1,\"data\":\(jsonString!),\"content_type\":\"json\",\"timestamp\":\"\",\"user_agent\":\"iphone\"}"
        let jsonData = payloadString.data(using: .utf8)
        let payloadWithUserObject = try? decoder.decode(Payload<User>.self, from: jsonData!)

        let payloadJsonBytes = try? encoder.encode(payloadWithUserObject)
        
        let userJson = try? JSONSerialization.jsonObject(with: payloadJsonBytes!, options: []) as! [String: AnyHashable]
        
        let originalJson = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyHashable]
        
        XCTAssertEqual(originalJson, userJson, "The original json is not equal to the payload and user generated json: Original: \(originalJson) | Generated: \(userJson)")

    }

}
