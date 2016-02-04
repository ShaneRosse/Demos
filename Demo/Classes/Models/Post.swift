//
//  Post.swift
//  Demo
//
//  Created by Shane Rosse on 2/2/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import Foundation

class Post : ModelBase, ModelProtocol {
    var cName : String?
    var cMessage : String?
    var cMessageDate : String?
    var cID : NSNumber?
    
    
    override func objectMapping() -> Dictionary<String, String>{
        
        let objectMapping = [
            "cName":"name",
            "cMessage":"message",
            "cMessageDate":"message_date",
            "cID":"id"
        ]
        
        return objectMapping
        
    }
    
}
