//
//  Preferences.swift
//  Swabbr
//
//  Created by James Bal on 14-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct Preferences: Decodable {
    var api_url: String
    var url_path: String
}

extension Preferences {
    
    static func getAPIPreferences(enviroment: String) -> Preferences {
        let url = Bundle.main.url(forResource: "Preferences", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let preferences = try? PropertyListDecoder().decode(Dictionary<String, Preferences>.self, from: data)
        return preferences![enviroment]!
    }
    
}
