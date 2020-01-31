//
//  NotificationRegistrationService.swift
//  Swabbr
//
//  Created by James Bal on 16-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class NotificationRegistrationService: NetworkProtocol {
    
    var endPoint: String = "notifications"
    
    static let shared = NotificationRegistrationService()
    
    func register(deviceToken: Data) {
        
        let handle = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        var request = buildUrl(path: "register", authorization: true)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(DeviceInstallation(handle: handle))
        request.addValue("text/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseData { (response) in
            #if DEBUG
            print("Notification status code: \(String(describing: response.response?.statusCode))")
            #endif
        }
        
    }
    
    func unregister() {
        
        var request = buildUrl(path: "unregister", authorization: true)
        request.httpMethod = "DELETE"
        AF.request(request).responseData { (response) in
            #if DEBUG
            print("Notification unregister status code: \(String(describing: response.response?.statusCode))")
            #endif
        }
        
    }
    
}
