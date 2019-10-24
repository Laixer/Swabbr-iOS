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

    override func setUp() {
        
        jsonString = "{\"id\": \"0\", \"firstName\": \"Apple\", \"lastName\": \"Swift\", \"gender\": \"M\", \"country\": \"Germany\", \"email\": \"apple@swift.com\", \"birthdate\": \"02/06/2014\", \"timezone\": \"+2\", \"nickname\": \"AppleIsTheBest\", \"profileImageUrl\": \"image.png\", \"interests\": [\"Apple\", \"Swift\", \"Innovation\"], \"totalVlogs\": 2, \"totalFollowers\":6, \"totalFollowing\": 2014, \"longitude\": \"53.00003\", \"latitude\": \"53.00003\"}"
        decoder = JSONDecoder()
        
    }

    override func tearDown() {
        
        jsonString = nil
        decoder = nil
        
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

        XCTAssert(user!.birthdate.iso8601() == expectedDateString, "The user birthdate: \(user!.birthdate.iso8601()) is not the same as: \(expectedDateString)")
    }
    
    
    func testPayloadWithUserObject() {
        
        let payloadString = "{\"protocol\":\"swabbr\",\"protocol_version\":1,\"data_type\":\"notification\",\"data_type_version\":1,\"data\":\(jsonString!),\"content_type\":\"json\",\"timestamp\":\"\",\"user_agent\":\"iphone\"}"
        let jsonData = payloadString.data(using: .utf8)
        let payloadWithUserObject = try? decoder.decode(Payload<User>.self, from: jsonData!)
        
        
        XCTAssert((payloadWithUserObject!._protocol == "swabbr" && payloadWithUserObject!.innerData.gender == User.Gender.Male), "Payload contains wrong data")

    }

}
