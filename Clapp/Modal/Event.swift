//
//  Event.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation

class Event {
    
    enum EventType {
        case CONFERENCE
        case MEETING
        case COMPETITION
        case PARTY
        case WORKSHOP
        case TRIP
        case NIGHTOUT
        case TRAINING
        
        func toString() -> String{
            switch self {
            case .CONFERENCE: return "Conference"
            case .MEETING: return "Meeting"
            case .COMPETITION: return "Competition"
            case .PARTY: return "Party"
            case .WORKSHOP: return "Workshop"
            case .TRIP: return "Trip"
            case .NIGHTOUT: return "Night out"
            case .TRAINING: return "Training"
            }
        }
        
        static func stringToEventType(typeAsString : String?) -> EventType? {
            if let type = typeAsString {
                switch type.uppercased() {
                    case "CONFERENCE": return EventType.CONFERENCE
                    case "MEETING": return EventType.MEETING
                    case "COMPETITION": return EventType.COMPETITION
                    case "PARTY": return EventType.PARTY
                    case "WORKSHOP": return EventType.WORKSHOP
                    case "TRIP": return EventType.TRIP
                    case "NIGHT OUT": return EventType.NIGHTOUT
                    case "TRAINING": return EventType.TRAINING
                    default: return nil
                }
            }
            return nil
        }
        
        static func asStringArray() -> [String] {
            return ["Conference", "Meeting", "Competition", "Party", "Workshop", "Trip", "Night out", "Training"]
        }
        
        static func count() -> Int {
            return self.asStringArray().count
        }
    }
    
    enum EventPrivacy {
        case GLOBAL
        case LOCAL
        case CLUB
        case GROUP
        case PRIVATE
        
        func toString() -> String{
            switch self {
            case .GLOBAL: return "Global"
            case .LOCAL: return "Local"
            case .CLUB: return "Club"
            case .GROUP: return "Group"
            case .PRIVATE: return "Private"
            }
        }
        
        static func stringToEventPrivacy(privacyAsString : String?) -> EventPrivacy? {
            if let privacy = privacyAsString {
                switch privacy.uppercased() {
                case "GLOBAL": return EventPrivacy.GLOBAL
                case "LOCAL": return EventPrivacy.LOCAL
                case "CLUB": return EventPrivacy.CLUB
                case "GROUP": return EventPrivacy.GROUP
                case "PRIVATE": return EventPrivacy.PRIVATE
                default: return nil
                }
            }
            return nil
        }
        
        static func asStringArray() -> [String] {
            return ["Global", "Local", "Club", "Group", "Private"]
        }
        
        static func count() -> Int {
            return self.asStringArray().count
        }
    }
    
    var event_id : UInt32?
    var event_type : EventType?
    var title : String?
    var description : String?
    var dateTime : UInt32?
    var dateString : String?
    var timeString : String?
    var place : String?
    var mapLink : String?
    var mapList : [String]?
    var clappers : [UInt32]?
    var image_name : String?
    var club_name : String?
    var club_icon_name : String?
    var club_id : UInt32?
    var creator_id : UInt32?
    var create_time : UInt32?
    var passed : Bool?
    var privacy : EventPrivacy?
    var chatroom_id : UInt32?
    var contacts_list : [UInt32]?
    
    init() {
        
    }
    
    init(title : String?, description : String?, imageName : String?, date : String?, time : String?, place : String?,
         eventType : EventType?, privacy : EventPrivacy?, clubName : String?, clubIcon : String?) {
        self.title = title
        self.description = description
        self.image_name = imageName
        self.dateString = date
        self.timeString = time
        self.place = place
        self.event_type = eventType
        self.privacy = privacy
        self.club_name = clubName
        self.club_icon_name = clubIcon
    }
}
