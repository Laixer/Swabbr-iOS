//
//  AuthNetwork.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class AuthNetwork: NetworkProtocol, AuthDataSourceProtocol {
    
    var endPoint: String = "login"
    
    func login(loginUser: LoginUser, completionHandler: @escaping (Int, AuthorizedUser) -> Void) {
        endPoint = "login"
        AF.request(buildUrl(), method: .get, parameters: loginUser).responseDecodable { (response: DataResponse<AuthorizedUser>) in
            switch response.result {
            case .success(let authorizedUser):
                completionHandler(response.response?.statusCode ?? 404, authorizedUser)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func register(registrationUser: RegistrationUser, completionHandler: @escaping (Int, AuthorizedUser) -> Void) {
        endPoint = "register"
        AF.request(buildUrl(), method: .get, parameters: registrationUser).responseDecodable { (response: DataResponse<AuthorizedUser>) in
            switch response.result {
            case .success(let authorizedUser):
                completionHandler(response.response?.statusCode ?? 404, authorizedUser)
            case .failure(let error):
                print(error)
            }
        }
    }
}
