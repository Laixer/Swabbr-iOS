//
//  Payload.swift
//  Swabbr
//
//  Created by James Bal on 21-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class Payload: PayloadProtocol {
    
    let _protocol: String
    let _protocolVersion: Int
    private let dataType: DataType
    let dataTypeVersion: Int
    var innerData: Any?
    private var contentType: ContentType?
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
        
        innerData = nil
        
        contentType = try container.decode(ContentType.self, forKey: CodingKeys.contentType)
        timestamp = try container.decode(String.self, forKey: CodingKeys.timestamp)
        userAgent = try container.decode(String.self, forKey: CodingKeys.userAgent)
        
        try dataHandling(container)
        
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
        
        // TODO: add innerData

    }
    
    internal func dataHandling(_ container: KeyedDecodingContainer<Payload.CodingKeys>) throws {}
    
}

protocol PayloadProtocol: Codable {
    /**
     Handle the retrieved data correctly according to the needs of the data.
     - parameter container: A decoders storage object which holds all the coupled values.
     - Throws: Throws an when it is not able to decode a certain value in the codingkeys list.
    */
    func dataHandling(_ container: KeyedDecodingContainer<Payload.CodingKeys>) throws
}
