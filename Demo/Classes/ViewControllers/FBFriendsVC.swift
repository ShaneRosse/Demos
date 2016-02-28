//
//  FBFriendsVC.swift
//  Demo
//
//  Created by Shane Rosse on 2/23/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

public var friends: Array<String>!

class FBFriendsVC: UITableViewController, FBSDKLoginButtonDelegate {
    
    internal func addFriends(fri: String) {
        friends.append(fri)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = []
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destination:FBLoginVC = storyboard.instantiateViewControllerWithIdentifier("FBShield") as! FBLoginVC
        let fbLoginButton:FBSDKLoginButton = destination.buildLoginButton()
        fbLoginButton.delegate = self
        
        //this only works if the view controllers are called the correct name
        self.presentViewController(destination, animated: false) { () -> Void in
        }
    }
    
    internal func fillGraph() {
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            if !token.hasGranted("user_friends") {
                return
            }
        }
        print("Permission Found\n")
        FBSDKGraphRequest.init(graphPath: "/me/taggable_friends?limit=1000000", parameters: nil).startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, ao: AnyObject!, err: NSError!) -> Void in
            let nsData = self.jsonToNSData(ao)
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(nsData!, options: .AllowFragments)
                if let people = jsonData.valueForKey("data") {
                    for each in people as! Array<AnyObject> {
                        if let result = each["name"] {
                            let res = result as! String
                            print(res)
                            self.addFriends(res)
                        }
                    }
                    friends.sortInPlace()
                }
            } catch {
                print("JSON Error")
            }
        }
    }
    
    func jsonToNSData(json: AnyObject) -> NSData? {
        do {
            return try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let friends = friends {
            return friends.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FBFriend", forIndexPath: indexPath)

        // Configure the cell...
        if let friends = friends {
            cell.textLabel!.text = friends[indexPath.row]
//            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        return cell
    }
    
    
    /*!
    @abstract Sent to the delegate when the button was used to login.
    @param loginButton the sender
    @param result The results of the login
    @param error The error (if any) from the login
    */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let _ = FBSDKAccessToken.currentAccessToken() {
            self.fillGraph()
        }
    }
    
    /*!
    @abstract Sent to the delegate when the button was used to logout.
    @param loginButton The button that was clicked.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
