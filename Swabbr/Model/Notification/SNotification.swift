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
        case FollowedProfileLive = "followed_profile_live"
        case InactiveUserMotivate = "inactive_user_motivate"
        case InactiveUnwatchedVlogs = "inactive_unwatched_vlogs"
        case InactiveVlogRecordRequest = "inactive_vlog_record_request"
        case VlogGainedLikes = "vlog_gained_likes"
        case VlogNewReaction = "vlog_new_reaction"
        case VlogRecordRequest = "vlog_record_request"
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
        
        title = try container.decode(String.self, forKey: CodingKeys.title)
        message = try container.decode(String.self, forKey: CodingKeys.message)
        clickAction = try container.decode(ClickAction.self, forKey: CodingKeys.clickAction)
        
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
