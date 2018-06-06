//
//  User.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation

class User {
    
    enum Gender {
        case MALE
        case FEMALE
        case OTHER
        
        func toString() -> String {
            switch self {
            case .MALE: return "Male"
            case .FEMALE: return "Female"
            case .OTHER: return "Other"
            }
        }
        
        static func asStringArray() -> [String] {
            return ["Male", "Female", "Other"]
        }
        
        static func count() -> Int {
            return self.asStringArray().count
        }
    }
    
    var name : String?
    var surname : String?
    var email : String?
    var gender : Gender?
    var id : UInt32?
    var dob : UInt32?
    var university_id : UInt32?
    
    var image_name : String?
    var following_clubs : [UInt32]?
    var following_events : [UInt32]?
    var clappers : [UInt32]?
    
    var create_time : UInt32?
    
    //Titles
    
    var events_created : [UInt32]?
    var events_attended : [UInt32]?
    
    //Message Box
    
    init() {
        
    }
    
    init(name : String?) {
        self.name = name
    }
    
    init(name : String?, email : String?) {
        self.name = name
        self.email = email
    }
}
