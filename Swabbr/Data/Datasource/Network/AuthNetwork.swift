//
//  AuthNetwork.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class AuthNetwork: NetworkProtocol, AuthDataSourceProtocol {
    
    var endPoint: String = "authentication"
    
    func login(loginUser: LoginUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void) {
        var request = buildUrl(path: "login")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(loginUser)
        request.addValue("text/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseData { response in
            guard let data = response.result.value else {
                completionHandler(nil, "Server Error")
                return
            }
            
            if let authUser = try? JSONDecoder().decode(AuthorizedUser.self, from: data) {
                UserDefaults.standard.set(loginUser.rememberMe, forKey: "rememberMe")
                KeychainService.shared.set(key: "access_token", value: authUser.accessToken)
                completionHandler(authUser, nil)
            }
            
            if let error = try? JSONDecoder().decode(SError.self, from: data) {
                completionHandler(nil, error.message)
            }
        }
    }
    
    func register(registrationUser: RegistrationUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void) {
        var request = buildUrl(path: "register")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(registrationUser)
        request.addValue("text/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseData { response in
            guard let data = response.result.value else {
                completionHandler(nil, "Server Error")
                return
            }
            
            if let authUser = try? JSONDecoder().decode(AuthorizedUser.self, from: data) {
                UserDefaults.standard.set(false, forKey: "rememberMe")
                KeychainService.shared.set(key: "access_token", value: authUser.accessToken)
                completionHandler(authUser, nil)
            }
            
            if let error = try? JSONDecoder().decode(SError.self, from: data) {
                completionHandler(nil, error.message)
            }
        }
    }
    
    func logout(completionHandler: @escaping (String?) -> Void) {
        var request = buildUrl(path: "logout", authorization: true)
        request.httpMethod = "DELETE"
        AF.request(request).response(completionHandler: { (response) in
            switch response.result {
            case .success:
                NotificationRegistrationService.shared.unregister()
                UserDefaults.standard.set(false, forKey: "rememberMe")
                KeychainService.shared.remove(key: "access_token")
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        })
    }
}
