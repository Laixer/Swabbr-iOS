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
    
    func mapToBusiness() -> AuthorizedUserModel {
        return AuthorizedUserModel(accessToken: accessToken,
                                   user: user.mapToBusiness(),
                                   userSettings: userSettings.mapToBusiness())
    }
    
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(user, forKey: .user)
        try container.encode(userSettings, forKey: .userSettings)
    }
    
}

// MARK: mapToEntity
extension AuthorizedUser {
    static func mapToEntity(model: AuthorizedUserModel) -> AuthorizedUser {
        return AuthorizedUser(accessToken: model.accessToken,
                              user: User.mapToEntity(model: model.user),
                              userSettings: UserSettings.mapToEntity(model: model.userSettings))
    }
}
