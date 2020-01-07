//
//  AuthorizedUser.swift
//  Swabbr
//
//  Created by James Bal on 16-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct AuthorizedUser {
    
    let accessToken: String
    let user: User
    let userSettings: UserSettings
    
}
    
extension AuthorizedUser: Codable {
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "token", user, userSettings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        userSettings = try container.decode(UserSettings.self, forKey: .userSettings)
        user = try container.decode(User.self, forKey: .user)
        
        UserDefaults.standard.setAccessToken(value: accessToken)
    }
    
}
