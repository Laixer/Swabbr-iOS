//
//  PushTemplate.swift
//  Swabbr
//
//  Created by James Bal on 15-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct SNotification {

    let clickAction: ClickAction
    let object: AnyObject?
    
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
        case clickAction = "click_action"
        case object
    }

}

// MARK: Codable
extension SNotification: Codable {
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        clickAction = try container.decode(ClickAction.self, forKey: .clickAction)
        
        switch clickAction {
        case .followedProfileLive:
            object = try container.decode(ObjectId.self, forKey: .object) as AnyObject
        case .inactiveUserMotivate:
            object = nil
        case .inactiveUnwatchedVlogs:
            object = nil
        case .inactiveVlogRecordRequest:
            object = nil
        case .vlogGainedLikes:
            object = nil
        case .vlogNewReaction:
            object = nil
        case .vlogRecordRequest:
            object = try container.decode(SLivestreamNotification.self, forKey: .object) as AnyObject
        }

    }
    
    func encode(to encoder: Encoder) throws {
        return
    }
}

struct ObjectId: Decodable {
    
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
    }
    
}
