//
//  DeviceInstallation.swift
//  Swabbr
//
//  Created by James Bal on 15-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct DeviceInstallation: Codable {
    
    let installationId: String
    let pushChannel: String
    let platform = "apns"
    var tags: [String]
    var templates: Dictionary<String, PushTemplate>
    
    init(withInstallationId installationId: String, andPushChannel pushChannel: String) {
        self.installationId = installationId
        self.pushChannel = pushChannel
        self.tags = [String]()
        self.templates = Dictionary<String, PushTemplate>()
    }
    
}
