//
//  BackgroundVC.swift
//  Demo
//
//  Created by Shane Rosse on 2/4/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit


class BackgroundVC: UITableViewController {
    
    var workQueue: dispatch_queue_t?
    var imageArray: Array<String> = ["https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg",
    
    "http://www.wired.com/wp-content/uploads/images_blogs/wiredscience/2012/08/Mars-in-95-Rover1.jpg",
    
    "http://news.brown.edu/files/article_images/MarsRover1.jpg",
    
    "http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg",
    
    "https://upload.wikimedia.org/wikipedia/commons/f/fa/Martian_rover_Curiosity_using_ChemCam_Msl20111115_PIA14760_MSL_PIcture-3-br2.jpg",
    
    "http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",
    
    "http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",
    
    "http://www.nasa.gov/sites/default/files/thumbnails/image/journey_to_mars.jpeg",
    
    "http://i.space.com/images/i/000/021/072/original/mars-one-colony-2025.jpg?1375634917",
    
    "http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"]
    
    var imageDictionary = [String: UIImage]()

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var imageTable: UITableView!
    
    @IBAction func button1Action(sender: AnyObject) {
        workQueue = dispatch_queue_create("com.itp.serialqueue", nil)
        for (var i = 0; i < 10; i++) {
            dispatch_async(workQueue!, {
                [i] () -> Void in
                self.performLongRunningTaskForIteration(i)
            })
        }
        registerBackgroundTask();
    }
    @IBAction func button2Action(sender: AnyObject) {
        workQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        for (var i = 0; i < 10; i++) {
            dispatch_async(workQueue!, {
                [i] () -> Void in
                self.performLongRunningTaskForIteration(i)
            })
        }
        endBackgroundTask()
    }
    @IBAction func button3Action(sender: AnyObject) {
    }
    
    func performLongRunningTaskForIteration(iteration: Int) -> Void {
        NSThread.sleepForTimeInterval(1)
        if (UIApplication.sharedApplication().backgroundTimeRemaining < NSTimeInterval(20*60)) {
            return;
        }
        let test = UIImage(data: NSData(contentsOfURL: (NSURL(string: imageArray[iteration]))!)!)
        imageDictionary[imageArray[iteration]] = test
        reloadTableData()
        print("Task \(iteration) completed")
    }
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        NSLog("Background task ended.")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        initImageDataArray()
        reloadTableData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tableview
    func reloadTableData() {
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                self.imageTable.reloadData()
            })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return imageArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ImageCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = imageArray[indexPath.row];
        cell.imageView?.image = imageDictionary[imageArray[indexPath.row]]
        print(imageDictionary[imageArray[indexPath.row]])
        return cell;
    }


}
