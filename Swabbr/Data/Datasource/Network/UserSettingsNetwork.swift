//
//  UserSettingsNetwork.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class UserSettingsNetwork: NetworkProtocol, UserSettingsDataSourceProtocol {
    
    var endPoint: String = "userSettings"
    
    func get(completionHandler: @escaping (UserSettings?) -> Void) {
        AF.request(buildUrl()).responseDecodable { (response: DataResponse<UserSettings>) in
            switch response.result {
            case .success(let userSettings):
                completionHandler(userSettings)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
                // failure handling
            }
        }
    }
    
    func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
}
