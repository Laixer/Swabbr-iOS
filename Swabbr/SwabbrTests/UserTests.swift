//
//  UserTests.swift
//  SwabbrTests
//
//  Created by James Bal on 09-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import XCTest
@testable import Swabbr

class UserTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func testJSONToUser() {
        let jsonString = "[{\"id\": \"0\", \"firstName\": \"Apple\", \"lastName\": \"Swift\", \"gender\": \"M\", \"country\": \"Germany\", \"email\": \"apple@swift.com\", \"birthdate\": \"02/06/2014\", \"timezone\": \"+2\", \"nickname\": \"AppleIsTheBest\", \"profileImageUrl\": \"image.png\", \"interests\": [\"Apple\", \"Swift\", \"Innovation\"], \"totalVlogs\": 2, \"totalFollowers\":6, \"totalFollowing\": 2014, \"longitude\": \"53.00003\", \"latitude\": \"53.00003\"}]"
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        let users = try? decoder.decode([User].self, from: jsonData!)
        XCTAssertNotNil(users![0], "The json string does not conform the user model")
    }
    
    func testErrorMessageWhenConvertToFloatFails() {
        let jsonString = "[{\"id\": \"0\", \"firstName\": \"Apple\", \"lastName\": \"Swift\", \"gender\": \"M\", \"country\": \"Germany\", \"email\": \"apple@swift.com\", \"birthdate\": \"02/06/2014\", \"timezone\": \"+2\", \"nickname\": \"AppleIsTheBest\", \"profileImageUrl\": \"image.png\", \"interests\": [\"Apple\", \"Swift\", \"Innovation\"], \"totalVlogs\": 2, \"totalFollowers\":6, \"totalFollowing\": 2014, \"longitude\": \"53.00003\", \"latitude\": \"Test\"}]"
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode([User].self, from: jsonData!)) { (error) in
            print(error)
        }
        
    }

}
