//
//  NotificationView.swift
//  SwiftNotificationManager
//
//  Created by John on 16/05/2015.
//  Copyright (c) 2015 Audio Y. All rights reserved.
//

import UIKit
// This enum has a declared value type in order to be able to store it and retrieve it from a dictionary (which only accepts references)
enum NotificationType:Int{
    case Positive
    case Negative
    case Loading
}

class NotificationView: UIView {
    
    let messageLabel = UILabel()
    let activityIndicatorView = UIActivityIndicatorView()
    var type:NotificationType!
    
    init(message:String, type:NotificationType) {
        super.init(frame: CGRectMake(0, -80, ScreenConstants.width, 80))
        
        self.type = type
        
        // Change the background colour depending on the message
        if type == .Positive{
            self.backgroundColor = UIColor.greenColor() // CHANGE THE COLOUR TO WHATEVER YOU WANT
        }
        else if type == .Negative{
            self.backgroundColor = UIColor.redColor() // CHANGE THE COLOUR TO WHATEVER YOU WANT
        }
        
        // Adapt the label
        //var font = UIFont(name: "OpenSans-Bold", size: 15.0)
        messageLabel.frame = CGRectMake(10, 20, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 20)
        messageLabel.text = message
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.whiteColor() // CHANGE THE COLOUR TO WHATEVER YOU WANT
        //messageLabel.font = font!
        
        // Special case! The loading notification!
        if type == .Loading{
            self.backgroundColor = UIColor.blueColor() // CHANGE THE COLOUR TO WHATEVER YOU WANT
            messageLabel.frame = CGRectMake(10, 50, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 50)
            messageLabel.numberOfLines = 1
            
            activityIndicatorView.frame = CGRectMake(10, 20, CGRectGetWidth(self.frame) - 20, 30)
            //let activityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 20, CGRectGetWidth(self.frame) - 20, 30))
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            self.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
        }
        
        // Add subviews
        self.addSubview(messageLabel)
        
        // Register to know when the device is rotated (the notifications are sent through UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications() in AppDelegate.swift)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetLayout", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        // Don't forget to remove oneself from observing the notification when deallocated or there is a crash
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func resetLayout(){
        
        self.frame = CGRectMake(0, CGRectGetMinY(self.frame), ScreenConstants.width, 80)
        
        messageLabel.frame = CGRectMake(10, 20, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 20)
        
        if type == .Loading{
            messageLabel.frame = CGRectMake(10, 50, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 50)
            activityIndicatorView.frame = CGRectMake(10, 20, CGRectGetWidth(self.frame) - 20, 30)
        }
    }

}
