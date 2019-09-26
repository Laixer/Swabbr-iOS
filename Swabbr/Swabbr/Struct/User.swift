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
        
        let idString = try container.decode(String.self, forKey: CodingKeys.id)
        guard let idInt = Int(idString) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.id], debugDescription: "Could not parse json key to Int object")
            throw DecodingError.dataCorrupted(context)
        }
        id = idInt
        
        firstName = try container.decode(String.self, forKey: CodingKeys.firstName)
        lastName = try container.decode(String.self, forKey: CodingKeys.lastName)
        gender = try container.decode(Gender.self, forKey: CodingKeys.gender)
        country = try container.decode(String.self, forKey: CodingKeys.country)
        email = try container.decode(String.self, forKey: CodingKeys.email)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+0:00")
        let birthdateString = try container.decode(String.self, forKey: CodingKeys.birthdate)
        birthdate = dateFormatter.date(from: birthdateString)!
        
        timezone = try container.decode(String.self, forKey: CodingKeys.timezone)
        username = try container.decode(String.self, forKey: CodingKeys.username)
        profileImageUrl = try container.decode(String.self, forKey: CodingKeys.profileImageUrl)
        interests = try container.decode([String].self, forKey: CodingKeys.interests)
        totalVlogs = try container.decode(Int.self, forKey: CodingKeys.totalVlogs)
        totalFollowers = try container.decode(Int.self, forKey: CodingKeys.totalFollowers)
        totalFollowing = try container.decode(Int.self, forKey: CodingKeys.totalFollowing)
        
        let longitudeString = try container.decode(String.self, forKey: CodingKeys.longitude)
        guard let longitudeFloat = Float(longitudeString) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.longitude], debugDescription: "Could not parse json key to Float object")
            throw DecodingError.dataCorrupted(context)
        }
        longitude = longitudeFloat
        
        let latitudeString = try container.decode(String.self, forKey: CodingKeys.latitude)
        guard let latitudeFloat = Float(latitudeString) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.latitude], debugDescription: "Could not parse json key to Float object")
            throw DecodingError.dataCorrupted(context)
        }
        latitude = latitudeFloat
        
    }
    
}
