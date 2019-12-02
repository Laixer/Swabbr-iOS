//
//  Preferences.swift
//  Swabbr
//
//  Created by James Bal on 14-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

struct ApiPreferences: Decodable {
    static var shared: ApiPreferences = getAPIPreferences(enviroment: .release)
    var api_url: String
    var url_path: String
}

extension ApiPreferences {
    
    enum Enviroment: String {
        case test = "test"
        case release = "release"
    }
    
    /**
     Get the appropriate api data from the supporting plist file.
     - parameter enviroment: An enviroment value.
     - Returns: A preference containing an api url and url path.
    */
    static func getAPIPreferences(enviroment: Enviroment = .release) -> ApiPreferences {
        let url = Bundle.main.url(forResource: "API-Preferences", withExtension: "plist")!
        let data = try? Data(contentsOf: url)
        let preferences = try? PropertyListDecoder().decode(Dictionary<String, ApiPreferences>.self, from: data!)
        return preferences![enviroment.rawValue]!
    }
    
}
