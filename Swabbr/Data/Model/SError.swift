//
//  SError.swift
//  Swabbr
//
//  Created by James Bal on 31-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class SError: Decodable {
    
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code, message
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
    }
    
}
