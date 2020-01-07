//
//  UserSettingsControllerService.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserSettingsControllerService {
    
    weak var delegate: UserSettingsViewControllerServiceDelegate?
    
    private let userSettingsUseCase = UserSettingsUseCase()
    
    public var userSettings: UserSettingsItem! {
        didSet {
            delegate?.retrievedUserSettings(self)
        }
    }
    
    /**
     Retrieve the user settings of the current user.
    */
    func getUserSettings() {
        userSettingsUseCase.get(refresh: false) { (userSettingsModel) in
            self.userSettings = UserSettingsItem.mapToPresentation(userSettingsModel: userSettingsModel!)
        }
    }
    
    /**
     Update the user settings to the new changes.
     - parameter userSettingsItem: A new UserSettingsItem object.
    */
    func updateUserSettings(userSettingsItem: UserSettingsItem) {
        userSettingsUseCase.updateUserSettings(userSettings: userSettingsItem.mapToBusiness()) { (errorString) in
            self.delegate?.updatedUserSettings(errorString: errorString)
        }
    }
    
}

protocol UserSettingsViewControllerServiceDelegate: class {
    func retrievedUserSettings(_ sender: UserSettingsControllerService)
    func updatedUserSettings(errorString: String?)
}
