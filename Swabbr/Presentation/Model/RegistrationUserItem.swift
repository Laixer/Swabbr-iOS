//
//  RegistrationUserItem.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct RegistrationUserItem {
    
    var firstName: String
    var lastName: String
    var gender: Int
    var country: String
    var email: String
    var password: String
    var birthdate: Date
    var timezone: String
    var username: String
    var profileImageUrl: String?
    var isPrivate: Bool
    var phoneNumber: String
    
    func mapToBusiness() -> RegistrationUserModel {
        return RegistrationUserModel(firstName: firstName,
                                    lastName: lastName,
                                    gender: gender,
                                    country: country,
                                    email: email,
                                    password: password,
                                    birthdate: birthdate.iso8601(),
                                    timezone: timezone,
                                    username: username,
                                    profileImageUrl: profileImageUrl ?? "",
                                    isPrivate: isPrivate,
                                    phoneNumber: phoneNumber)
    }
    
}
