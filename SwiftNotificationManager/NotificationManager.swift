//
//  NotificationManager.swift
//  SwiftNotificationManager
//
//  Created by John on 16/05/2015.
//  Copyright (c) 2015 Audio Y. All rights reserved.
//

import Foundation
import UIKit

class NotificationManager {
    
    static let sharedInstance = NotificationManager() // Now it's a Singleton
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!! // The topmost view controller
    var notificationsToShowArray:NSMutableArray = [] // An array that holds normal notifications that need displaying if we are already displaying one
    var isExecuting:Bool = false
    
    /*
    lazy var notificationQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Notification queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    */
    
    init(){
        println("NotificationManager is initialised")
    }
    
    func displayMessage(message:String, type:NotificationType, duration:Double?){
        
        // Loading notifications have their own method, displayLoadingMessage
        if type == .Loading{
            return
        }
        
        var defaultDuration = 0.8 // The default duration
        if let duration = duration{
            defaultDuration = duration // If the value is different from 0.8, e.g. 1.6, pass it as the duration for this view
        }
        
        // If we are already showing a notification, log this one in the notificationsToShowArray array
        if self.isExecuting{
            // Log this operation to be executed when done
            var operationDictionary:[String:AnyObject] = ["message":message, "typeHash":type.rawValue]
            if let duration = duration{
                operationDictionary["duration"] = duration
            }
            self.notificationsToShowArray.addObject(operationDictionary)
            return
        }
        
        self.isExecuting = true
        
        let notificationView = NotificationView(message: message, type: type)
        self.rootViewController.view.addSubview(notificationView)
        
        // UI updates happen on the main thread
        dispatch_async(dispatch_get_main_queue(),{
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
                // Bring the notification down
                notificationView.frame.origin.y = 0
                }, completion: { finished in
                    
                    UIView.animateWithDuration(0.8, delay: defaultDuration, options: .CurveEaseOut, animations: {
                        // Bring the notification up
                        notificationView.frame.origin.y -= CGRectGetHeight(notificationView.frame)
                        }, completion: { finished in
                            // Remove the notification and declare oneself as free to show another notification
                            notificationView.removeFromSuperview()
                            self.isExecuting = false
                            
                            // Check if we have any notifications to show in the array
                            if self.notificationsToShowArray.count > 0{
                                if let notificationDictionary = self.notificationsToShowArray.firstObject as? [String:AnyObject], notificationMessage:String = notificationDictionary["message"] as? String, notificationTypeValue:Int =  notificationDictionary["typeHash"] as? Int{
                                    let notificationType:NotificationType = NotificationType(rawValue: notificationTypeValue)!
                                    self.notificationsToShowArray.removeObject(notificationDictionary)
                                    self.displayMessage(notificationMessage, type: notificationType, duration: notificationDictionary["duration"] as? Double)
                                }
                            }
                    })
            })
        })
        
    }
    
    // Display the loading message and return a completionHandler to the calling method so that the loading notification can be removed
    func displayLoadingMessage(message:String) -> (() -> ())?{

        
        // If we are already showing a notification, log this one in the notificationsToShowArray array
        if isExecuting{
            // Log this operation to be executed when done
            let operationDictionary:[String:AnyObject] = ["message":message, "typeHash":NotificationType.Loading.rawValue]
            notificationsToShowArray.addObject(operationDictionary)
            return nil
        }
        
        isExecuting = true
        
        let notificationView = NotificationView(message: message, type: .Loading)
        self.rootViewController.view.addSubview(notificationView)
        
        dispatch_async(dispatch_get_main_queue(),{
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
                // Bring the notification down
                notificationView.frame.origin.y = 0
                }, completion: nil)
        })
        
        
        // This is the code executed when completionhandler is called
        var completionHandler:() -> () = {
            
            dispatch_async(dispatch_get_main_queue(),{
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations: {
                    // Bring the notification up
                    notificationView.frame.origin.y -= CGRectGetHeight(notificationView.frame)
                    }, completion: { finished in
                        // Remove the notification and declare oneself as free to show another notification
                        notificationView.removeFromSuperview()
                        self.isExecuting = false
                        
                        // Check if we have any notifications to show in the array
                        if self.notificationsToShowArray.count > 0{
                            if let notificationDictionary = self.notificationsToShowArray.firstObject as? [String:AnyObject], notificationMessage:String = notificationDictionary["message"] as? String, notificationTypeValue:Int =  notificationDictionary["typeHash"] as? Int{
                                let notificationType:NotificationType = NotificationType(rawValue: notificationTypeValue)!
                                self.notificationsToShowArray.removeObject(notificationDictionary)
                                self.displayMessage(notificationMessage, type: notificationType, duration: notificationDictionary["duration"] as? Double)
                            }
                        }
                })
            })
        }
        
        return completionHandler
    }
    
}