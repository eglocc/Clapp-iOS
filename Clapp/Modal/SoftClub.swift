//
//  SoftClub.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation

class SoftClub: Club, Codable {

    var events : [SoftEvent]?
    
    init(name : String?, iconName : String?, events : [SoftEvent]?) {
        super.init(name: name, iconName: iconName)
        setEvents(events: events)
    }
    
    func setEvents(events : [SoftEvent]?) {
        self.events = events
        if events != nil {
            for event in events! {
                event.club_id = self.club_id
            }
        }
    }
    
    func toAnyObject() -> Dictionary<String, Any?> {
        if self.events != nil {
            let events : NSArray = self.events!.map {$0.toAnyObject()} as NSArray
            return [
                "id" : self.club_id,
                "name" : self.name,
                "iconName" : self.icon_name,
                "events" : events
            ]
        } else {
            return [
                "id" : self.club_id,
                "name" : self.name,
                "iconName" : self.icon_name,
                "events" : nil
            ]
        }
    }
}
