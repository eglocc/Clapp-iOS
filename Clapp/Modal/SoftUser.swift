//
//  SoftUser.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation

class SoftUser: User, Codable {
    
    override init(name : String?) {
        super.init(name : name)
    }
    
    override init(name : String?, email : String?) {
        super.init(name : name, email : email)
    }
    
    func toAnyObject() -> Dictionary<String, Any?> {
        return [
            "id" : self.id,
            "name" : self.name
        ]
    }
}
