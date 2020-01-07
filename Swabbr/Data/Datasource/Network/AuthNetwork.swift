//
//  AuthNetwork.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_try

import Alamofire

class AuthNetwork: NetworkProtocol, AuthDataSourceProtocol {
    
    var endPoint: String = "authentication"
    
    func login(loginUser: LoginUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void) {
        var request = buildUrl(path: "login")
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(loginUser)
        request.addValue("text/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseDecodable { (response: DataResponse<AuthorizedUser>) in
            switch response.result {
            case .success(let authorizedUser):
                completionHandler(authorizedUser, nil)
            case .failure:
                print(String.init(data: response.data!, encoding: .utf8)!)
                completionHandler(nil, String.init(format: "%d: %@",response.response!.statusCode, String.init(data: response.data!, encoding: .utf8)!))
            }
        }
    }
    
    func register(registrationUser: RegistrationUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void) {
        var request = buildUrl(path: "register")
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(registrationUser)
        print(try! JSONEncoder().encode(registrationUser))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseDecodable { (response: DataResponse<AuthorizedUser>) in
            switch response.result {
            case .success(let authorizedUser):
                completionHandler(authorizedUser, nil)
            case .failure:
                completionHandler(nil, String.init(format: "%d: %@",response.response!.statusCode, String.init(data: response.data!, encoding: .utf8)!))
            }
        }
    }
}
