//
//  PostsManager.swift
//  Demo
//
//  Created by Shane Rosse on 2/2/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import Foundation

class PostsManager: ManagerBase {
    
    class func readPostsWithHandler(callback:(posts : Array<Post>?, error: AnyObject?)->()) {
        ServerAPIManager.sharedInstance.readResource(ServerAPIManager.Resources.Posts) {
            (data, error) -> () in
            
            if error != nil {
                callback(posts: nil, error: error)
            } else {
                var posts : Array<Post> = [Post]()
                
                if let items = data as? Array<NSDictionary> {
                    for item in items {
                        let post : Post = Post()
                        post.fromDictionary(item as! Dictionary<String, AnyObject>, withRootNode: "message")
                        posts.append(post)
                    }
                }
                //line 42 ViewController
                callback(posts: posts, error: nil)
            }
        }
    }
    
    class func createPost(post : Post, withHandler callback: (success : Bool, error: AnyObject?) -> Void) {
        
        let postData = post.toDictionary(withRootNode: "message")
        
        // create the resource
        ServerAPIManager.sharedInstance.createResource(ServerAPIManager.Resources.Posts, data: postData) {
            (data, error) -> () in
            
            if error != nil {
                // line 42 NewPostVC
                callback(success: false, error: error)
            } else {
                callback(success: true, error: nil)
            }
        }
    }
    
    class func deletePost(post : Post, withHandler callback: (success : Bool, error: AnyObject?) -> Void) {
//        let postData = post.toDictionary(withRootNode: "message")
        ServerAPIManager.sharedInstance.deleteResource(ServerAPIManager.Resources.Posts, data: post) {
            (data, error) -> () in
            if error != nil {
                callback(success: false, error: error)
            } else {
                callback(success: true, error: nil)
            }
        }
    }
}