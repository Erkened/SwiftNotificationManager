//
//  NotificationManager.swift
//  Repnote
//
//  Created by Jonathan Neumann on 31/08/2017.
//  Copyright © 2017 Audioy. All rights reserved.
//

import Foundation
import UIKit

typealias notificationCompletion = () -> ()

enum NotificationType{
    case normal
    case loading
}

class NotificationManager {
    
    static let shared = NotificationManager() // Now it's a Singleton
    
    private static let notificationHeight: CGFloat = 80
    private let serialQueue = DispatchQueue(label: "com.example.serialqueue")
    private let group = DispatchGroup()
    
    private init(){
        print("NotificationManager is initialised")
    }
    
    // Source: https://stackoverflow.com/questions/27601758/how-to-use-gcd-to-control-animation-sequence
    // Source: https://www.allaboutswift.com/dev/2016/7/12/gcd-with-swfit3
    // Source: https://medium.com/@irinaernst/swift-3-0-concurrent-programming-with-gcd-5ee51e89091f
    
    func displayMessage(_ message: String, completionHandler: (() -> ())? = nil){
        display(message, type: .normal) { (_) in
            if let completionHandler = completionHandler{
                completionHandler()
            }
        }
    }
    
    func displayLoadingMessage(_ message: String, completionHandler: @escaping (@escaping notificationCompletion) -> ()){
        
        display(message, type: .loading) { (completion) in
            completionHandler(completion)
        }
    }
    
    private func display(_ message:String, type: NotificationType, completionHandler: @escaping (@escaping notificationCompletion) -> ()){
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return print("Couldn't access the root view controller, therefore couldn't display the notification") }
        
        let notificationView = NotificationView(message: message)
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = notificationView.bottomAnchor.constraint(equalTo: rootViewController.view.topAnchor)
        
        serialQueue.async {
            self.group.enter()
            
            DispatchQueue.main.async {
                
                rootViewController.view.addSubview(notificationView)
                NSLayoutConstraint.activate([
                    notificationView.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor),
                    notificationView.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor),
                    bottomConstraint,
                    notificationView.heightAnchor.constraint(equalToConstant: NotificationManager.notificationHeight)
                    ])
                rootViewController.view.layoutIfNeeded()
                
                if #available(iOS 11, *) {
                    bottomConstraint.constant = NotificationManager.notificationHeight + rootViewController.view.safeAreaInsets.top
                } else {
                    bottomConstraint.constant = NotificationManager.notificationHeight
                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    rootViewController.view.layoutIfNeeded()
                }, completion: { (finished) in
                    
                    switch type{
                    case .normal:
                        
                        bottomConstraint.constant = 0
                        UIView.animate(withDuration: 0.8, delay: 1.6, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            rootViewController.view.layoutIfNeeded()
                        }, completion: { (finished) in
                            notificationView.removeFromSuperview()
                            self.group.leave()
                            completionHandler({})
                        })
                        break
                    case .loading:
                        
                        let completion: notificationCompletion = {
                            
                            bottomConstraint.constant = 0
                            
                            UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                rootViewController.view.layoutIfNeeded()
                            }, completion: { (finished) in
                                notificationView.removeFromSuperview()
                                self.group.leave()
                            })
                        }
                        
                        completionHandler(completion)
                        break
                    }
                    
                })
            }
            
            _ = self.group.wait(timeout: DispatchTime.distantFuture)
        }
    }
}
