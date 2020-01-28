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
        AF.request(request).responseDecodable { (response: DataResponse<AuthorizedUser>) in
            switch response.result {
            case .success(let authUser):
                UserDefaults.standard.set(loginUser.rememberMe, forKey: "rememberMe")
                KeychainService.shared.set(key: "access_token", value: authUser.accessToken)
                completionHandler(authUser, nil)
            case .failure(let error):
                completionHandler(nil,
                                  error.localizedDescription)
            }
        }
    }
    
    func register(registrationUser: RegistrationUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void) {
        var request = buildUrl(path: "register")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(registrationUser)
        request.addValue("text/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseDecodable { (response: DataResponse<AuthorizedUser>) in
            switch response.result {
            case .success(let authUser):
                UserDefaults.standard.set(false, forKey: "rememberMe")
                KeychainService.shared.set(key: "access_token", value: authUser.accessToken)
                completionHandler(authUser, nil)
            case .failure(let error):
                completionHandler(nil,
                                  error.localizedDescription)
            }
        }
    }
    
    func logout(completionHandler: @escaping (String?) -> Void) {
        var request = buildUrl(path: "logout", authorization: true)
        request.httpMethod = "DELETE"
        AF.request(request).response(completionHandler: { (response) in
            switch response.result {
            case .success:
                UserDefaults.standard.set(false, forKey: "rememberMe")
                KeychainService.shared.remove(key: "access_token")
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        })
    }
}
