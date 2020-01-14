//
//  UserSettings.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct UserSettings {

    let isPrivate: Bool
    let dailyVlogRequestLimit: Int
    let followMode: Int
    
    func mapToBusiness() -> UserSettingsModel {
        return UserSettingsModel(isPrivate: isPrivate,
                                 dailyVlogRequestLimit: dailyVlogRequestLimit,
                                 followMode: followMode)
    }
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case isPrivate, dailyVlogRequestLimit, followMode
    }
    
}

// MARK: Codable
extension UserSettings: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        dailyVlogRequestLimit = try container.decode(Int.self, forKey: .dailyVlogRequestLimit)
        followMode = try container.decode(Int.self, forKey: .followMode)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isPrivate, forKey: .isPrivate)
        try container.encode(dailyVlogRequestLimit, forKey: .dailyVlogRequestLimit)
        try container.encode(followMode, forKey: .followMode)
        
    }
    
}

// MARK: mapToEntity
extension UserSettings {
    static func mapToEntity(model: UserSettingsModel) -> UserSettings {
        return UserSettings(isPrivate: model.isPrivate, dailyVlogRequestLimit: model.dailyVlogRequestLimit, followMode: model.followMode)
    }
}
