//
//  Payload.swift
//  Swabbr
//
//  Created by James Bal on 21-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class Payload<T: Codable>: Codable {

    let _protocol: String
    let _protocolVersion: Int
    private let dataType: DataType
    let dataTypeVersion: Int
    let innerData: T
    private var contentType: ContentType
    var timestamp: String?
    var userAgent: String?
    
    private enum DataType: String, Codable {
        case User = "user"
        case Notification = "notification"
    }
    
    private enum ContentType: String, Codable {
        case JSON = "json"
    }
    
    enum CodingKeys: String, CodingKey {
        case _protocol = "protocol"
        case _protocolVersion = "protocol_version"
        case dataType = "data_type"
        case dataTypeVersion = "data_type_version"
        case innerData = "data"
        case contentType = "content_type"
        case userAgent = "user_agent"
        case timestamp
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _protocol = try container.decode(String.self, forKey: CodingKeys._protocol)
        _protocolVersion = try container.decode(Int.self, forKey: CodingKeys._protocolVersion)
        dataType = try container.decode(DataType.self, forKey: CodingKeys.dataType)
        dataTypeVersion = try container.decode(Int.self, forKey: CodingKeys.dataTypeVersion)
        
        innerData = try container.decode(T.self, forKey: CodingKeys.innerData)
        
        contentType = try container.decode(ContentType.self, forKey: CodingKeys.contentType)
        timestamp = try container.decode(String.self, forKey: CodingKeys.timestamp)
        userAgent = try container.decode(String.self, forKey: CodingKeys.userAgent)
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(_protocol, forKey: CodingKeys._protocol)
        try container.encode(_protocolVersion, forKey: CodingKeys._protocolVersion)
        try container.encode(dataType, forKey: CodingKeys.dataType)
        try container.encode(dataTypeVersion, forKey: CodingKeys.dataTypeVersion)
        try container.encode(contentType, forKey: CodingKeys.contentType)
        try container.encode(timestamp, forKey: CodingKeys.timestamp)
        try container.encode(userAgent, forKey: CodingKeys.userAgent)
        
        try container.encode(innerData, forKey: CodingKeys.innerData)

    }
    
}
