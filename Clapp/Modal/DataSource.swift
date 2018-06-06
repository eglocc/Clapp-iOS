//
//  DataSource.swift
//  Clapp
//
//  Created by Ergiz Work on 23/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol DataSourceDelegate {
    func eventListLoaded(eventList : [SoftEvent])
    func eventListUpdated(eventList : [SoftEvent])
    func eventDetailLoaded(event : SoftEvent)
    func memberListLoaded(memberList : [SoftUser])
    func memberDetailLoaded(member : SoftUser)
    func clubListLoaded(clubList : [SoftClub])
    func clubDetailLoaded(club : SoftClub)
}

extension DataSourceDelegate {
    func eventListLoaded(eventList : [SoftEvent]) {}
    func eventListUpdated(eventList : [SoftEvent]) {}
    func eventDetailLoaded(event : SoftEvent) {}
    func memberListLoaded(memberList : [SoftUser]) {}
    func memberDetailLoaded(member : SoftUser) {}
    func clubListLoaded(clubList : [SoftClub]) {}
    func clubDetailLoaded(club : SoftClub) {}
}

class DataSource {
    
    private static var sharedInstance : DataSource = {
        let dataSource = DataSource()
        return dataSource
    }()
    
    var delegate : DataSourceDelegate?
    var events : [SoftEvent]?
    var members : [SoftUser]?
    var clubs : [SoftClub]?
    
    var clubNames = [String]()
    var clubDictionary = [String : UInt32]()
    var clubDataDictionary = [UInt32 : SoftClub]()
    
    var memberNames = [String]()
    var memberDictionary = [String : UInt32]()
    var memberDataDictionary = [UInt32 : SoftUser]()
    
    private init() {}
    
    class func shared() -> DataSource {
        return sharedInstance
    }
    
    func loadEventList(query : DatabaseQuery) {
        query.observe(.value) { (snapshot) in
            var events = [SoftEvent]()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let value = rest.value as? NSDictionary
                let eventID = value?["id"] as? UInt32 ?? nil
                let title = value?["title"] as? String ?? nil
                let description = value?["description"] as? String ?? nil
                let imageName = value?["imageName"] as? String ?? nil
                let dateText = value?["dateText"] as? String ?? nil
                let timeText = value?["timeText"] as? String ?? nil
                let place = value?["place"] as? String ?? nil
                let typeAsString = value?["eventType"] as? String ?? nil
                let eventType = Event.EventType.stringToEventType(typeAsString: typeAsString)
                let privacyAsString = value?["privacy"] as? String ?? nil
                let privacy = Event.EventPrivacy.stringToEventPrivacy(privacyAsString: privacyAsString)
                let clubID = value?["clubid"] as? UInt32 ?? nil
                let clubName = value?["clubName"] as? String ?? nil
                let clubIconName = value?["clubIcon"] as? String ?? nil
                
                let event = SoftEvent(title: title, description: description, imageName: imageName, date: dateText, time: timeText, place: place, eventType: eventType, privacy: privacy, clubName: clubName, clubIcon: clubIconName)
                event.event_id = eventID
                event.club_id = clubID
                events.append(event)
            }
            self.events = events
            self.delegate?.eventListLoaded(eventList: events)
        }
    }
    
    func updateEventList(query : DatabaseQuery) {
        query.observeSingleEvent(of: .value) { (snapshot) in
            var events = [SoftEvent]()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let value = rest.value as? NSDictionary
                let eventID = value?["id"] as? UInt32 ?? nil
                let title = value?["title"] as? String ?? nil
                let description = value?["description"] as? String ?? nil
                let imageName = value?["imageName"] as? String ?? nil
                let dateText = value?["dateText"] as? String ?? nil
                let timeText = value?["timeText"] as? String ?? nil
                let place = value?["place"] as? String ?? nil
                let typeAsString = value?["eventType"] as? String ?? nil
                let eventType = Event.EventType.stringToEventType(typeAsString: typeAsString)
                let privacyAsString = value?["privacy"] as? String ?? nil
                let privacy = Event.EventPrivacy.stringToEventPrivacy(privacyAsString: privacyAsString)
                let clubID = value?["clubid"] as? UInt32 ?? nil
                let clubName = value?["clubName"] as? String ?? nil
                let clubIconName = value?["clubIcon"] as? String ?? nil
                
                let event = SoftEvent(title: title, description: description, imageName: imageName, date: dateText, time: timeText, place: place, eventType: eventType, privacy: privacy, clubName: clubName, clubIcon: clubIconName)
                event.event_id = eventID
                event.club_id = clubID
                events.append(event)
            }
            self.events?.append(contentsOf: events)
            self.delegate?.eventListUpdated(eventList: events)
        }
    }
    
    func addChildAddedListener(query : DatabaseQuery) {
        query.observe(.childAdded) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let eventID = value?["id"] as? UInt32 ?? nil
            let title = value?["title"] as? String ?? nil
            let description = value?["description"] as? String ?? nil
            let imageName = value?["imageName"] as? String ?? nil
            let dateText = value?["dateText"] as? String ?? nil
            let timeText = value?["timeText"] as? String ?? nil
            let place = value?["place"] as? String ?? nil
            let typeAsString = value?["eventType"] as? String ?? nil
            let eventType = Event.EventType.stringToEventType(typeAsString: typeAsString)
            let privacyAsString = value?["privacy"] as? String ?? nil
            let privacy = Event.EventPrivacy.stringToEventPrivacy(privacyAsString: privacyAsString)
            let clubID = value?["clubid"] as? UInt32 ?? nil
            let clubName = value?["clubName"] as? String ?? nil
            let clubIconName = value?["clubIcon"] as? String ?? nil
            let event = SoftEvent(title: title, description: description, imageName: imageName, date: dateText, time: timeText, place: place, eventType: eventType, privacy: privacy, clubName: clubName, clubIcon: clubIconName)
            event.event_id = eventID
            event.club_id = clubID
            self.events?.append(event)
            self.delegate?.eventDetailLoaded(event: event)
        }
    }
    
    func loadEventDetail(query : DatabaseQuery) {
        query.observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let eventID = value?["id"] as? UInt32 ?? nil
            let title = value?["title"] as? String ?? nil
            let description = value?["description"] as? String ?? nil
            let imageName = value?["imageName"] as? String ?? nil
            let dateText = value?["dateText"] as? String ?? nil
            let timeText = value?["timeText"] as? String ?? nil
            let place = value?["place"] as? String ?? nil
            let typeAsString = value?["eventType"] as? String ?? nil
            let eventType = Event.EventType.stringToEventType(typeAsString: typeAsString)
            let privacyAsString = value?["privacy"] as? String ?? nil
            let privacy = Event.EventPrivacy.stringToEventPrivacy(privacyAsString: privacyAsString)
            let clubID = value?["clubid"] as? UInt32 ?? nil
            let clubName = value?["clubName"] as? String ?? nil
            let clubIconName = value?["clubIcon"] as? String ?? nil
            let event = SoftEvent(title: title, description: description, imageName: imageName, date: dateText, time: timeText, place: place, eventType: eventType, privacy: privacy, clubName: clubName, clubIcon: clubIconName)
            event.event_id = eventID
            event.club_id = clubID
            self.delegate?.eventDetailLoaded(event: event)
        }
    }
    
    func loadMemberList(query : DatabaseQuery) {
        query.observe(.value) { (snapshot) in
            var members = [SoftUser]()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let value = rest.value as? NSDictionary
                let id = value?["id"] as? UInt32 ?? nil
                let name = value?["name"] as? String ?? nil
                let member = SoftUser(name: name)
                member.id = id
                members.append(member)
                self.memberDictionary[name!] = id
                self.memberNames.append(name!)
                self.memberDataDictionary[id!] = member
            }
            self.members = members
            self.delegate?.memberListLoaded(memberList: members)
        }
    }
    
    func loadMemberDetail(query : DatabaseQuery) {
        query.observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let id = value?["id"] as? UInt32 ?? nil
            let name = value?["name"] as? String ?? nil
            let member = SoftUser(name: name)
            member.id = id
            self.delegate?.memberDetailLoaded(member: member)
        }
    }
    
    func loadClubList(query : DatabaseQuery) {
        query.observe(.value) { (snapshot) in
            var clubs = [SoftClub]()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let value = rest.value as? NSDictionary
                let id = value?["id"] as? UInt32 ?? nil
                let name = value?["name"] as? String ?? nil
                let iconName = value?["iconName"] as? String ?? nil
                let club = SoftClub(name: name, iconName: iconName, events: nil)
                club.club_id = id
                if let events = self.events {
                    var clubEvents = [SoftEvent]()
                    for event in events {
                        if event.club_id == club.club_id {
                            clubEvents.append(event)
                        }
                    }
                    club.setEvents(events: clubEvents)
                }
                clubs.append(club)
                self.clubNames.append(name!)
                self.clubDictionary[name!] = id
                self.clubDataDictionary[id!] = club
            }
            self.clubs = clubs
            self.delegate?.clubListLoaded(clubList: clubs)
        }
    }
    
    func loadClubDetail(query : DatabaseQuery) {
        query.observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let id = value?["id"] as? UInt32 ?? nil
            let name = value?["name"] as? String ?? nil
            let iconName = value?["iconName"] as? String ?? nil
            let club = SoftClub(name: name, iconName: iconName, events: nil)
            club.club_id = id
            if let events = self.events {
                var clubEvents = [SoftEvent]()
                for event in events {
                    if event.club_id == id {
                        clubEvents.append(event)
                    }
                }
                club.setEvents(events: clubEvents)
            }
            self.delegate?.clubDetailLoaded(club: club)
        }
    }
}
