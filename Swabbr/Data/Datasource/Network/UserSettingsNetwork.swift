//
//  UserSettingsNetwork.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_try

import Alamofire

class UserSettingsNetwork: NetworkProtocol, UserSettingsDataSourceProtocol {
    
    var endPoint: String = "users/self/settings"
    
    func get(completionHandler: @escaping (UserSettings?) -> Void) {
        AF.request(buildUrl(path: "get", authorization: true)).responseDecodable { (response: DataResponse<UserSettings>) in
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
    
    func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping (UserSettings?, String?) -> Void) {
        var request = buildUrl(path: "update", authorization: true)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(userSettings)
        request.addValue("text/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseDecodable { (response: DataResponse<UserSettings>) in
            switch response.result {
            case .success(let userSettings):
                completionHandler(userSettings, nil)
            case .failure:
                completionHandler(nil,
                                  String.init(format: "%d: %@", response.response!.statusCode, String.init(data: response.data!, encoding: .utf8)!))
            }
        }
    }
}
