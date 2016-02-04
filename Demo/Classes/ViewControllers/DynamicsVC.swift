//
//  DynamicsVC.swift
//  Demo
//
//  Created by Shane Rosse on 1/22/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit

class DynamicsVC: UIViewController {
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var boundaries: UICollisionBehavior!
    var characteristic: UIDynamicItemBehavior!
    var counter: Int!
    
    @IBOutlet weak var generateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = 0;
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        boundaries = UICollisionBehavior()
        characteristic = UIDynamicItemBehavior()
        characteristic.elasticity = 0.5
        characteristic.angularResistance = 0.000001
        boundaries.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(boundaries)
        animator.addBehavior(gravity)
        animator.addBehavior(characteristic)
        
        // Do any additional setup after loading the view, typically from a nib.
        generateButton.bringSubviewToFront(self.view)
        generateButton.addTarget(self, action: Selector("generate:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func generate(sender: AnyObject) {
        print("working")
        let r_val = UInt32(300) + 50
        let b_val: UInt32 = arc4random_uniform(r_val)
        let x_val = Int(b_val)
        let circle = UIView(frame: CGRect(x: x_val, y: 10, width: 50, height: 50))
        
        circle.backgroundColor = UIColor.blueColor()
        circle.layer.cornerRadius = circle.frame.size.width/2
        circle.clipsToBounds = true
        circle.layer.borderColor = UIColor.blackColor().CGColor
        circle.layer.borderWidth = 3
        view.addSubview(circle)
        boundaries.addItem(circle)
        gravity.addItem(circle)
        characteristic.addItem(circle)
    }
}

