//
//  Club.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation

class Club {
    
    var name : String?
    var icon_name : String?
    var club_id : UInt32?
    var president_id : UInt32?
    var members : [UInt32]?
    var clappers : [UInt32]?
    var upcoming_events : [UInt32]?
    var passed_events : [UInt32]?
    var request_list : [UInt32]?
    
    //xEventClappersList
    
    var member_list_public : Bool?
    
    init() {
        
    }
    
    init(name : String?, iconName : String?) {
        self.name = name
        self.icon_name = iconName
    }
}
