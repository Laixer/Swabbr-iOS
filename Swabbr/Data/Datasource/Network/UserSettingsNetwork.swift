//
//  UserSettingsNetwork.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class UserSettingsNetwork: NetworkProtocol, UserSettingsDataSourceProtocol {
    
    var endPoint: String = "users/self/settings"
    
    func get(completionHandler: @escaping (UserSettings?, String?) -> Void) {
        AF.request(buildUrl(path: "get", authorization: true)).responseDecodable { (response: DataResponse<UserSettings>) in
            switch response.result {
            case .success(let userSettings):
                completionHandler(userSettings, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
                // failure handling
            }
        }
    }
    
    func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping (UserSettings?, String?) -> Void) {
        var request = buildUrl(path: "update", authorization: true)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(userSettings)
        request.addValue("text/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseDecodable { (response: DataResponse<UserSettings>) in
            switch response.result {
            case .success(let userSettings):
                completionHandler(userSettings, nil)
            case .failure(let error):
                completionHandler(nil,
                                  error.localizedDescription)
            }
        }
    }
}
