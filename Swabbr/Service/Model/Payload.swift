//
//  Payload.swift
//  Swabbr
//
//  Created by James Bal on 21-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable identifier_name

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
        
        _protocol = try container.decode(String.self, forKey: ._protocol)
        _protocolVersion = try container.decode(Int.self, forKey: ._protocolVersion)
        dataType = try container.decode(DataType.self, forKey: .dataType)
        dataTypeVersion = try container.decode(Int.self, forKey: .dataTypeVersion)
        
        innerData = try container.decode(T.self, forKey: .innerData)
        
        contentType = try container.decode(ContentType.self, forKey: .contentType)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        userAgent = try container.decode(String.self, forKey: .userAgent)
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(_protocol, forKey: ._protocol)
        try container.encode(_protocolVersion, forKey: ._protocolVersion)
        try container.encode(dataType, forKey: .dataType)
        try container.encode(dataTypeVersion, forKey: .dataTypeVersion)
        try container.encode(contentType, forKey: .contentType)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(userAgent, forKey: .userAgent)
        
        try container.encode(innerData, forKey: .innerData)

    }
    
}
