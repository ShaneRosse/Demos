//
//  NewPostVC.swift
//  Demo
//
//  Created by Shane Rosse on 2/2/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitButtonTouched(sender: AnyObject) {
        // get and format the current date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let formattedDate = dateFormatter.stringFromDate(NSDate())
        
        let post : Post = Post()
        post.cName = self.name.text
        post.cMessage = self.message.text
        post.cMessageDate = formattedDate
        
        
        PostsManager.createPost(post) {
            (success, error) -> Void in
            
            //implement your own error handling
            print(success)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
