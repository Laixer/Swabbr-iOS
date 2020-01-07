//
//  UserSettingsItem.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct UserSettingsItem {
    
    var isPrivate: Bool
    var dailyVlogRequestLimit: Int
    var followMode: Int
    
    init(userSettingsModel: UserSettingsModel) {
        isPrivate = userSettingsModel.isPrivate
        dailyVlogRequestLimit = userSettingsModel.dailyVlogRequestLimit
        followMode = userSettingsModel.followMode
    }
    
    func mapToBusiness() -> UserSettingsModel {
        return UserSettingsModel(isPrivate: isPrivate, dailyVlogRequestLimit: dailyVlogRequestLimit, followMode: followMode)
    }
    
}

extension UserSettingsItem {
    static func mapToPresentation(userSettingsModel: UserSettingsModel) -> UserSettingsItem {
        return UserSettingsItem(userSettingsModel: userSettingsModel)
    }
}

extension UserSettingsItem: Equatable {
    static func == (lhs: UserSettingsItem, rhs: UserSettingsItem) -> Bool {
        return lhs.isPrivate == rhs.isPrivate && lhs.dailyVlogRequestLimit == rhs.dailyVlogRequestLimit && lhs.followMode == rhs.followMode
    }
}
