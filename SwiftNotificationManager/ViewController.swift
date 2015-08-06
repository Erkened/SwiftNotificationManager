//
//  ViewController.swift
//  SwiftNotificationManager
//
//  Created by John on 16/05/2015.
//  Copyright (c) 2015 Audio Y. All rights reserved.
//

import UIKit

// Struct required for the button frames
struct ScreenConstants {
    
    static var size: CGRect = UIScreen.mainScreen().bounds
    static var width = size.width
    static var height = size.height
    static var scale:CGFloat = UIScreen.mainScreen().scale
}

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    let negativeNotificationButton = UIButton()
    let positiveNotificationButton = UIButton()
    let longerPositiveNotificationButton = UIButton()
    let loadingNotificationButton = UIButton()
    let removeLoadingNotificationButton = UIButton()
    var completionHandler:(() -> ())? // This stores the block to be executed to remove the loading notification

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)
        titleLabel.frame = CGRectMake(0, 0, ScreenConstants.width, ScreenConstants.height/6)
        titleLabel.text = "Swift Notification Manager"
        titleLabel.textAlignment = .Center
        titleLabel.font = font!
        
        // Create the different buttons
        negativeNotificationButton.frame = CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 20, ScreenConstants.width - 20, 40)
        negativeNotificationButton.layer.cornerRadius = 5
        negativeNotificationButton.setTitle("Negative notification", forState: .Normal)
        negativeNotificationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        negativeNotificationButton.addTarget(self, action: "displayNegativeNotification", forControlEvents: .TouchUpInside)
        negativeNotificationButton.backgroundColor = UIColor.redColor()
        
        positiveNotificationButton.frame = CGRectMake(10, CGRectGetMaxY(negativeNotificationButton.frame) + 20, ScreenConstants.width - 20, 40)
        positiveNotificationButton.layer.cornerRadius = 5
        positiveNotificationButton.setTitle("Positive notification", forState: .Normal)
        positiveNotificationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        positiveNotificationButton.addTarget(self, action: "displayPositiveNotification", forControlEvents: .TouchUpInside)
        positiveNotificationButton.backgroundColor = UIColor.greenColor()
        
        longerPositiveNotificationButton.frame = CGRectMake(10, CGRectGetMaxY(positiveNotificationButton.frame) + 20, ScreenConstants.width - 20, 40)
        longerPositiveNotificationButton.layer.cornerRadius = 5
        longerPositiveNotificationButton.setTitle("Longer positive notification", forState: .Normal)
        longerPositiveNotificationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        longerPositiveNotificationButton.addTarget(self, action: "displayLongerPositiveNotification", forControlEvents: .TouchUpInside)
        longerPositiveNotificationButton.backgroundColor = UIColor.greenColor()
        
        loadingNotificationButton.frame = CGRectMake(10, CGRectGetMaxY(longerPositiveNotificationButton.frame) + 20, ScreenConstants.width - 20, 40)
        loadingNotificationButton.layer.cornerRadius = 5
        loadingNotificationButton.setTitle("Loading notification", forState: .Normal)
        loadingNotificationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loadingNotificationButton.addTarget(self, action: "displayLoadingNotification", forControlEvents: .TouchUpInside)
        loadingNotificationButton.backgroundColor = UIColor.blueColor()
        
        removeLoadingNotificationButton.frame = CGRectMake(10, CGRectGetMaxY(loadingNotificationButton.frame) + 20, ScreenConstants.width - 20, 40)
        removeLoadingNotificationButton.layer.cornerRadius = 5
        removeLoadingNotificationButton.setTitle("Remove loading notification", forState: .Normal)
        removeLoadingNotificationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        removeLoadingNotificationButton.addTarget(self, action: "removeLoadingNotification", forControlEvents: .TouchUpInside)
        removeLoadingNotificationButton.backgroundColor = UIColor.blueColor()
        
        // Add subviews
        self.view.addSubview(titleLabel)
        self.view.addSubview(negativeNotificationButton)
        self.view.addSubview(positiveNotificationButton)
        self.view.addSubview(longerPositiveNotificationButton)
        self.view.addSubview(loadingNotificationButton)
        self.view.addSubview(removeLoadingNotificationButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Notification methods
    func displayNegativeNotification(){
        NotificationManager.sharedInstance.displayMessage("This is a negative notification", type: .Negative, duration: nil)
    }
    
    func displayPositiveNotification(){
        NotificationManager.sharedInstance.displayMessage("This is a positive notification", type: .Positive, duration: nil)
    }
    
    func displayLongerPositiveNotification(){
        NotificationManager.sharedInstance.displayMessage("This positive notification stays for longer", type: .Positive, duration: 2.0)
    }
    
    func displayLoadingNotification(){
        // The returnedCompletionHandler can be nil. Only set it as the completionHandler if it exists
        if let returnedCompletionHandler = NotificationManager.sharedInstance.displayLoadingMessage("Press the remove button when you want to"){
            completionHandler = returnedCompletionHandler
        }
    }
    
    func removeLoadingNotification(){
        if let completionHandler = completionHandler{
            completionHandler()
        }
    }

}

