//
//  LoginUser.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct LoginUser {

    var email: String
    var password: String
    var rememberMe: Bool

}

// MARK: Codable
extension LoginUser: Encodable {
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case email, password, rememberMe
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(rememberMe, forKey: .rememberMe)
    }
    
}

// MARK: mapToEntity
extension LoginUser {
    static func mapToEntity(model: LoginUserModel) -> LoginUser {
        return LoginUser(email: model.email,
                         password: model.password,
                         rememberMe: model.rememberMe)
    }
}
