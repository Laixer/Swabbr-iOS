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
    private let authUseCase = AuthUseCase()
    
    public var userSettings: UserSettingsItem!
    
    /**
     Retrieve the user settings of the current user.
    */
    func getUserSettings() {
        userSettingsUseCase.get(refresh: false) { (userSettingsModel, errorString) in
            guard let userSettingsModel = userSettingsModel else {
                self.delegate?.retrievedUserSettings(errorString: errorString)
                return
            }
            self.userSettings = UserSettingsItem.mapToPresentation(userSettingsModel: userSettingsModel)
            self.delegate?.retrievedUserSettings(errorString: nil)
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
    
    /**
     Logout the current account.
    */
    func logout() {
        authUseCase.logout { (errorString) in
            self.delegate?.logoutStatus(errorString: errorString)
        }
    }
    
}

protocol UserSettingsViewControllerServiceDelegate: class {
    func retrievedUserSettings(errorString: String?)
    func updatedUserSettings(errorString: String?)
    func logoutStatus(errorString: String?)
}
