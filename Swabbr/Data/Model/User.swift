//
//  User.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  Base class of an user

struct User {
    
    var id: String
    var firstName: String
    var lastName: String
    var gender: Int
    var country: String
    var email: String
    var birthdate: String
    var timezone: String
    var username: String
    var profileImageUrl: String
    var totalVlogs: Int
    var totalFollowers: Int
    var totalFollowing: Int
    var longitude: Float
    var latitude: Float
    var isPrivate: Bool
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
    */
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case birthdate = "birthDate"
        case username = "nickname",
        firstName,
        lastName,
        gender,
        country,
        email,
        timezone,
        profileImageUrl,
        totalVlogs,
        totalFollowers,
        totalFollowing,
        longitude,
        latitude,
        isPrivate
    }
    
    func mapToBusiness() -> UserModel {
        return UserModel(id: id,
                         firstName: firstName,
                         lastName: lastName,
                         gender: gender,
                         country: country,
                         email: email,
                         birthdate: birthdate,
                         timezone: timezone,
                         username: username,
                         profileImageUrl: profileImageUrl,
                         totalVlogs: totalVlogs,
                         totalFollowers: totalFollowers,
                         totalFollowing: totalFollowing,
                         longitude: longitude,
                         latitude: latitude,
                         isPrivate: isPrivate)
    }
    
}

// MARK: Codable
extension User: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(Int.self, forKey: .gender)
        country = try container.decode(String.self, forKey: .country)
        email = try container.decode(String.self, forKey: .email)

        birthdate = try container.decode(String.self, forKey: .birthdate)

        timezone = try container.decodeIfPresent(String.self, forKey: .timezone) ?? ""
        username = try container.decode(String.self, forKey: .username)
        profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl) ?? ""
        totalVlogs = try container.decode(Int.self, forKey: .totalVlogs)
        totalFollowers = try container.decode(Int.self, forKey: .totalFollowers)
        totalFollowing = try container.decode(Int.self, forKey: .totalFollowing)

        longitude = try container.decodeToType(Float.self, key: .longitude)
        latitude = try container.decodeToType(Float.self, key: .latitude)
        
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)

    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(gender, forKey: .gender)
        try container.encode(country, forKey: .country)
        try container.encode(email, forKey: .email)
        try container.encode(birthdate, forKey: .birthdate)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(username, forKey: .username)
        try container.encode(profileImageUrl, forKey: .profileImageUrl)
        try container.encode(totalVlogs, forKey: .totalVlogs)
        try container.encode(totalFollowers, forKey: .totalFollowers)
        try container.encode(totalFollowing, forKey: .totalFollowing)
        try container.encode(String(longitude), forKey: .longitude)
        try container.encode(String(latitude), forKey: .latitude)
        
    }

}

// MARK: mapToEntity
extension User {
    static func mapToEntity(model: UserModel) -> User {
        return User(id: model.id,
                    firstName: model.firstName,
                    lastName: model.lastName,
                    gender: model.gender,
                    country: model.country,
                    email: model.email,
                    birthdate: model.birthdate,
                    timezone: model.timezone,
                    username: model.username,
                    profileImageUrl: model.profileImageUrl,
                    totalVlogs: model.totalVlogs,
                    totalFollowers: model.totalFollowers,
                    totalFollowing: model.totalFollowing,
                    longitude: model.longitude,
                    latitude: model.latitude,
                    isPrivate: model.isPrivate)
    }
}
