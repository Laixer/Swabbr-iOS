//
//  SLivestreamNotification.swift
//  Swabbr
//
//  Created by James Bal on 23-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

struct SLivestreamNotification {
    let id: String
    let hostAddress: String
    let appName: String
    let streamName: String
    let port: UInt
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case hostAddress = "HostAddress"
        case appName = "AppName"
        case password = "Password"
        case port = "Port"
        case streamName = "StreamName"
        case username = "Username"
    }
}

extension SLivestreamNotification: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        hostAddress = try container.decode(String.self, forKey: .hostAddress)
        appName = try container.decode(String.self, forKey: .appName)
        streamName = try container.decode(String.self, forKey: .streamName)
        port = try container.decode(UInt.self, forKey: .port)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        
    }
    
}
