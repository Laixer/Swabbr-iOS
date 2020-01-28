//
//  Payload.swift
//  Swabbr
//
//  Created by James Bal on 21-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class Payload<T: Codable>: Codable {

    let pProtocol: String
    let pProtocolVersion: String
    private let dataType: String
    let dataTypeVersion: String
    let innerData: T
    private var contentType: String
    var timestamp: String
    var userAgent: String
    
    enum CodingKeys: String, CodingKey {
        case pProtocol = "protocol"
        case pProtocolVersion = "protocol_version"
        case dataType = "data_type"
        case dataTypeVersion = "data_type_version"
        case innerData = "data"
        case contentType = "content_type"
        case userAgent = "user_agent"
        case timestamp
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pProtocol = try container.decode(String.self, forKey: .pProtocol)
        pProtocolVersion = try container.decode(String.self, forKey: .pProtocolVersion)
        
        dataType = try container.decode(String.self, forKey: .dataType)
        dataTypeVersion = try container.decode(String.self, forKey: .dataTypeVersion)
        
        innerData = try container.decode(T.self, forKey: .innerData)
        
        contentType = try container.decode(String.self, forKey: .contentType)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        userAgent = try container.decode(String.self, forKey: .userAgent)
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pProtocol, forKey: .pProtocol)
        try container.encode(pProtocolVersion, forKey: .pProtocolVersion)
        try container.encode(dataType, forKey: .dataType)
        try container.encode(dataTypeVersion, forKey: .dataTypeVersion)
        try container.encode(contentType, forKey: .contentType)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(userAgent, forKey: .userAgent)
        
        try container.encode(innerData, forKey: .innerData)

    }
    
}
