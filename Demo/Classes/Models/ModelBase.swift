//
//  ModelBase.swift
//  Demo
//
//  Created by Shane Rosse on 2/2/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import Foundation

protocol ModelProtocol {
    // protocol definition goes here
    
    func objectMapping() -> Dictionary<String, String>
    
}

class ModelBase : NSObject {
    var name : String?
    var message : String?
    
    
    // overide from subclass
    func objectMapping() -> Dictionary<String, String>{
        let objecMapping = Dictionary<String, String>()
        return objecMapping
    }
    
    
    func fromDictionary(dict: Dictionary<String, AnyObject>, withRootNode rootNode: String){
        
        let propertyBag = dict[rootNode] as! Dictionary<String, AnyObject>
        
        fromDictionary(propertyBag)
        
    }
    
    func fromDictionary(dict : Dictionary<String, AnyObject>){
        
        // loop through each one of the mappings
        // objectKey & jsonKey are reference names to the data in objectMapping
        for (objectKey, jsonKey)  in self.objectMapping() {
            
            // set the value
            var jsonValue = dict[jsonKey]
            
            // if it's NSNull type then just skip it
            if(jsonValue is NSNull){
                continue
            }
            
//            guard var _ = jsonValue where jsonValue is String else {
//                jsonValue = String(jsonValue)
//                continue
//            }
            
            self.setValue(jsonValue, forKey: objectKey)
            
        }
        
    }
    
    func toDictionary(withRootNode rootNode: String) -> Dictionary<String, AnyObject>{
        
        let propertyBag = toDictionary()
        
        return [rootNode: propertyBag]
        
    }
    
    
    func toDictionary() -> Dictionary<String, AnyObject>{
        
        var dictionary = Dictionary<String, AnyObject>()
        
        // loop through each one of the mappings
        for (objectKey, jsonKey)  in self.objectMapping() {
            
            // set the value
            
            var objValue = self.valueForKey(objectKey)
            
            
            // if it's NSNull type then just skip it
            if(objValue is NSNull){
                continue
            }
//            guard var _ = objValue where objValue is String else {
//                objValue = String(objValue)
//                continue
//            }
            
            dictionary[jsonKey] = objValue
            
        }
        
        return dictionary
        
    }
    
}
