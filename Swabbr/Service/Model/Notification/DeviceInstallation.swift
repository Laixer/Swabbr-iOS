//
//  DeviceInstallation.swift
//  Swabbr
//
//  Created by James Bal on 15-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct DeviceInstallation: Encodable {
    
    let handle: String
    let platform = 0
    
    init(handle: String) {
        self.handle = handle
    }
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case platform, handle
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(platform, forKey: .platform)
        try container.encode(handle, forKey: .handle)
        
    }
    
}
