//
//  MessageBoardVC.swift
//  Demo
//
//  Created by Shane Rosse on 1/28/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit

class MessageBoardVC: UITableViewController {
    
    private var posts : Array<Post>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tableview 
    
    func reloadTableData() {
        PostsManager.readPostsWithHandler {
            (posts : Array<Post>?, error: AnyObject?) in
            self.posts = posts
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        }
            return 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
            
        let post : Post = self.posts[indexPath.row]
        cell.textLabel?.text = post.cName
        cell.detailTextLabel?.text = post.cMessage
        return cell;
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let post : Post = self.posts[indexPath.row]
            
            posts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            PostsManager.deletePost(post, withHandler: { (success, error) -> Void in
                print(success)
            })
            
            reloadTableData()

            
        }
    }
}
