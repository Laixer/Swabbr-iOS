//
//  User.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  Base class of an user

struct User {
    
    var id: Int
    var firstName: String
    var lastName: String
    var gender: Gender
    var country: String
    var email: String
    var birthdate: String
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
     Handles possible name convention differences.
     Put each value in their respected model variant.
    */
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, gender, country, email, birthdate, timezone, profileImageUrl, interests, totalVlogs, totalFollowers, totalFollowing, longitude, latitude
        case username = "nickname"
    }
    
    func mapToBusiness() -> UserModel {
        return UserModel(id: id,
                         firstName: firstName,
                         lastName: lastName,
                         gender: gender,
                         country: country,
                         email: email,
                         birthdate: DateFormatter().stringToBaseDate(format: "dd/MM/yyyy", value: birthdate)!,
                         timezone: timezone,
                         username: username,
                         profileImageUrl: profileImageUrl,
                         interests: interests,
                         totalVlogs: totalVlogs,
                         totalFollowers: totalFollowers,
                         totalFollowing: totalFollowing,
                         longitude: longitude,
                         latitude: latitude)
    }
}

// MARK: Codable
extension User: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeToType(Int.self, key: .id)

        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(Gender.self, forKey: .gender)
        country = try container.decode(String.self, forKey: .country)
        email = try container.decode(String.self, forKey: .email)

        birthdate = try container.decode(String.self, forKey: .birthdate)

        timezone = try container.decode(String.self, forKey: .timezone)
        username = try container.decode(String.self, forKey: .username)
        profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        interests = try container.decode([String].self, forKey: .interests)
        totalVlogs = try container.decode(Int.self, forKey: .totalVlogs)
        totalFollowers = try container.decode(Int.self, forKey: .totalFollowers)
        totalFollowing = try container.decode(Int.self, forKey: .totalFollowing)

        longitude = try container.decodeToType(Float.self, key: .longitude)
        latitude = try container.decodeToType(Float.self, key: .latitude)

    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(String(id), forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(gender, forKey: .gender)
        try container.encode(country, forKey: .country)
        try container.encode(email, forKey: .email)
        try container.encode(birthdate, forKey: .birthdate)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(username, forKey: .username)
        try container.encode(profileImageUrl, forKey: .profileImageUrl)
        try container.encode(interests, forKey: .interests)
        try container.encode(totalVlogs, forKey: .totalVlogs)
        try container.encode(totalFollowers, forKey: .totalFollowers)
        try container.encode(totalFollowing, forKey: .totalFollowing)
        try container.encode(String(longitude), forKey: .longitude)
        try container.encode(String(latitude), forKey: .latitude)
        
    }

}

public enum Gender: String, Codable {
    case male = "M"
    case female = "F"
    case unspecified = "O"
}
