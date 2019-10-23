//
//  User.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  Base class of an user

import Foundation

struct User: Codable {
    
    var id: Int
    var firstName: String
    var lastName: String
    var gender: Gender
    var country: String
    var email: String
    var birthdate: Date
    var timezone: String
    var username: String
    var profileImageUrl: String
    var interests: [String]
    var totalVlogs: Int
    var totalFollowers: Int
    var totalFollowing: Int
    var longitude: Float
    var latitude: Float
    
    /**
     Converts the value of gender to conform our model.
    */
    enum Gender: String, Codable {
        case Male = "M"
        case Female = "F"
        case Unspecified = "O"
    }
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
    */
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, gender, country, email, birthdate, timezone, profileImageUrl, interests, totalVlogs, totalFollowers, totalFollowing, longitude, latitude
        case username = "nickname"
    }
    
    /**
     This function makes the data conform to the model.
     It will try and parse the values to their correct value according to the model.
     - parameter decoder: The decoder built in swift to read the data from.
     - Throws: A decodingerror when the data can't be converted to their respective type.
    */
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeToType(Int.self, key: CodingKeys.id)
        
        firstName = try container.decode(String.self, forKey: CodingKeys.firstName)
        lastName = try container.decode(String.self, forKey: CodingKeys.lastName)
        gender = try container.decode(Gender.self, forKey: CodingKeys.gender)
        country = try container.decode(String.self, forKey: CodingKeys.country)
        email = try container.decode(String.self, forKey: CodingKeys.email)
        
        birthdate = DateFormatter().stringToBaseDate(format: "dd/MM/yyyy", value: try container.decode(String.self, forKey: CodingKeys.birthdate))!
        
        timezone = try container.decode(String.self, forKey: CodingKeys.timezone)
        username = try container.decode(String.self, forKey: CodingKeys.username)
        profileImageUrl = try container.decode(String.self, forKey: CodingKeys.profileImageUrl)
        interests = try container.decode([String].self, forKey: CodingKeys.interests)
        totalVlogs = try container.decode(Int.self, forKey: CodingKeys.totalVlogs)
        totalFollowers = try container.decode(Int.self, forKey: CodingKeys.totalFollowers)
        totalFollowing = try container.decode(Int.self, forKey: CodingKeys.totalFollowing)
        
        longitude = try container.decodeToType(Float.self, key: CodingKeys.longitude)
        latitude = try container.decodeToType(Float.self, key: CodingKeys.latitude)
        
    }
    
}
