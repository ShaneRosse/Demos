//
//  FBLoginVC.swift
//  Demo
//
//  Created by Shane Rosse on 2/23/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit
import FBSDKLoginKit

public var login_button: FBSDKLoginButton!

class FBLoginVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    public func buildLoginButton() -> FBSDKLoginButton! {
        login_button = FBSDKLoginButton()
        login_button.readPermissions = ["public_profile", "email", "user_friends"]
        return login_button
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        login_button.center = self.view.center
        self.view.addSubview(login_button)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(false) { () -> Void in
        }
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            if (!token.hasGranted("user_friends")) {
                (presentingViewController as? UINavigationController)?.popToRootViewControllerAnimated(true)
            }
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */ //

}
