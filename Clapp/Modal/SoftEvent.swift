//
//  SoftEvent.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation

class SoftEvent: Event, Codable {
    
    var imageData : Data?
    
    override init(title: String?, description: String?, imageName: String?, date: String?, time: String?, place: String?, eventType: EventType?, privacy: EventPrivacy?, clubName: String?, clubIcon: String?) {
        super.init(title: title, description: description, imageName: imageName, date: date, time: time, place: place, eventType: eventType, privacy: privacy, clubName: clubName, clubIcon: clubIcon)
    }
    
    override init() {
        super.init()
    }
    
    func toAnyObject() -> Dictionary<String, Any?> {
        return [
            "id" : self.event_id,
            "title" : self.title,
            "description" : self.description,
            "imageName" : self.image_name,
            "dateText" : self.dateString,
            "timeText" : self.timeString,
            "place" : self.place,
            "eventType" : self.event_type?.toString(),
            "privacy" : self.privacy?.toString(),
            "clubid" : self.club_id,
            "clubName" : self.club_name,
            "clubIcon" : self.club_icon_name
        ]
    }
}
