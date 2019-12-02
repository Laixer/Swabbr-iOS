//
//  PushTemplate.swift
//  Swabbr
//
//  Created by James Bal on 15-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct SNotification {

    let title: String
    let message: String
    let clickAction: ClickAction

    enum ClickAction: String, Decodable {
        case followedProfileLive = "followed_profile_live"
        case inactiveUserMotivate = "inactive_user_motivate"
        case inactiveUnwatchedVlogs = "inactive_unwatched_vlogs"
        case inactiveVlogRecordRequest = "inactive_vlog_record_request"
        case vlogGainedLikes = "vlog_gained_likes"
        case vlogNewReaction = "vlog_new_reaction"
        case vlogRecordRequest = "vlog_record_request"
    }
    
    enum CodingKeys: String, CodingKey {
        case title, message
        case clickAction = "click_action"
    }

}

// MARK: Codable
extension SNotification: Codable {
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)
        clickAction = try container.decode(ClickAction.self, forKey: .clickAction)
        
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
