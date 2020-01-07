//
//  RegistrationUser.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct RegistrationUser {
    
    var firstName: String
    var lastName: String
    var gender: Int
    var country: String
    var email: String
    var password: String
    var birthdate: String
    var timezone: String
    var username: String
    var profileImageUrl: String
    var isPrivate: Bool
    var phoneNumber: String
    
}

// MARK: Codable
extension RegistrationUser: Encodable {
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, gender, country, email, password, birthdate, timezone, profileImageUrl, phoneNumber
        case username = "nickname"
        case isPrivate = "isPrivate"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(gender, forKey: .gender)
        try container.encode(country, forKey: .country)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(birthdate, forKey: .birthdate)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(username, forKey: .username)
        try container.encode(profileImageUrl, forKey: .profileImageUrl)
        try container.encode(isPrivate, forKey: .isPrivate)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }
    
}

// MARK: mapToEntity
extension RegistrationUser {
    static func mapToEntity(model: RegistrationUserModel) -> RegistrationUser {
        return RegistrationUser(firstName: model.firstName,
                                lastName: model.lastName,
                                gender: model.gender,
                                country: model.country,
                                email: model.email,
                                password: model.password,
                                birthdate: model.birthdate,
                                timezone: model.timezone,
                                username: model.username,
                                profileImageUrl: model.profileImageUrl,
                                isPrivate: model.isPrivate,
                                phoneNumber: model.phoneNumber)
    }
}
