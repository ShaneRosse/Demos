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
    
    "http://img2.tvtome.com/i/u/28c79aac89f44f2dcf865ab8c03a4201.png",
    
    "http://news.brown.edu/files/article_images/MarsRover1.jpg",
        
    "https://loveoffriends.files.wordpress.com/2012/02/love-of-friends-117.jpg",
    
    "http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg",
        
    "http://www.facultyfocus.com/wp-content/uploads/images/iStock_000012443270Large150921.jpg",
    
    "https://upload.wikimedia.org/wikipedia/commons/f/fa/Martian_rover_Curiosity_using_ChemCam_Msl20111115_PIA14760_MSL_PIcture-3-br2.jpg",
    
    "http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",
    
    "http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",
    
    "http://www.ymcanyc.org/i/ADULTS%20groupspinning2%20FC.jpg",
    
    "http://www.dogslovewagtime.com/wp-content/uploads/2015/07/Dog-Pictures.jpg",
    
    "http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"]


    var imageDictionary = [String: UIImage]()

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var imageTable: UITableView!
    
    @IBAction func button1Action(sender: AnyObject) {
        workQueue = dispatch_queue_create("com.itp.serialqueue", nil)
        for (var i = 0; i < imageArray.count; i++) {
            dispatch_async(workQueue!, {
                [i] () -> Void in
                self.performLongRunningTaskForIteration(i)
            })
        }
        registerBackgroundTask();
    }
    @IBAction func button2Action(sender: AnyObject) {
        workQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        for (var i = 0; i < imageArray.count; i++) {
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
    
    func countFaces(countImage: UIImage) -> Int {
        let detectImg: CIImage = CIImage(image: countImage)!
        let options: Dictionary = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)
        let features: Array = detector.featuresInImage(detectImg)
        
        
        return features.count
    }
    
    func imgHueSat(alterImage: UIImage) -> UIImage {
        let inputImg: CIImage = CIImage(image: alterImage)!
        let expFilter: CIFilter = CIFilter(name: "CIExposureAdjust")!
        expFilter.setValue(inputImg, forKey: kCIInputImageKey)
        expFilter.setValue(1.0, forKey: kCIInputEVKey)
        
        let interImg = expFilter.outputImage
        
        let hueFilter: CIFilter = CIFilter(name: "CIHueAdjust")!
        hueFilter.setValue(interImg, forKey: kCIInputImageKey)
        hueFilter.setValue(1.0, forKey: kCIInputAngleKey)
        let resultImg = hueFilter.outputImage
        
        return UIImage(CIImage: resultImg!)
    }
    
    func imgBlur(alterImage: UIImage) -> UIImage {
        let inputImg: CIImage = CIImage(image: alterImage)!
        
        let blurFilter: CIFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(inputImg, forKey: kCIInputImageKey)
        blurFilter.setValue(5.0, forKey: kCIInputRadiusKey)
        let resultImg = blurFilter.outputImage
        
        return UIImage(CIImage: resultImg!)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ImageCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        var faceCount: Int = 0
        var cellImg: UIImage = UIImage()
        if let inputImage = imageDictionary[imageArray[indexPath.row]] {
            faceCount = countFaces(inputImage)
//            print(faceCount)
            var detStr: String = "No Faces Detected"
            if (faceCount != 0) {
                detStr = "\(faceCount) face(s) detected"
            }
            if (faceCount == 0) {
                cellImg = imgHueSat(inputImage)
            } else {
                cellImg = imgBlur(inputImage)
            }
            cell.textLabel?.text = detStr
            cell.imageView?.image = cellImg
        }
        return cell;
    }


}
