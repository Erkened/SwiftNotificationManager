//
//  NotificationTestViewController.swift
//  Repnote
//
//  Created by Jonathan Neumann on 31/08/2017.
//  Copyright © 2017 Audioy. All rights reserved.
//

import UIKit

class NotificationTestViewController: UIViewController {
    
    fileprivate var notificationCompletion: notificationCompletion?
    fileprivate var i = 0{
        didSet{
            notificationButton.setTitle("Display message \(i)", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addSubviewsAndSetupContraints()
    }
    
    // UI
    
    fileprivate lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 0
        return sv
    }()
    
    fileprivate lazy var notificationButton: UIButton = {
        let b = UIButton()
        b.setTitle("Display message \(self.i)", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)
        b.addTarget(self, action: #selector(displayMessage), for: .touchUpInside)
        return b
    }()
    
    fileprivate lazy var bumpButton: UIButton = {
        let b = UIButton()
        b.setTitle("Bump", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)
        b.addTarget(self, action: #selector(bump), for: .touchUpInside)
        return b
    }()
    
    fileprivate lazy var startLoadingButton: UIButton = {
        let b = UIButton()
        b.setTitle("Start loading", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)
        b.addTarget(self, action: #selector(startLoading), for: .touchUpInside)
        return b
    }()
    
    fileprivate lazy var stopLoadingButton: UIButton = {
        let b = UIButton()
        b.setTitle("Stop loading", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)
        b.addTarget(self, action: #selector(stopLoading), for: .touchUpInside)
        return b
    }()
}

extension NotificationTestViewController{
    func addSubviewsAndSetupContraints() {
        
        stackView.addArrangedSubview(notificationButton)
        stackView.addArrangedSubview(bumpButton)
        stackView.addArrangedSubview(startLoadingButton)
        stackView.addArrangedSubview(stopLoadingButton)
        view.addSubview(stackView)
        
        NSLayoutConstraint.useAndActivate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
            ])
    }
    
    @objc fileprivate func displayMessage(){
        NotificationManager.shared.displayMessage("Message \(i)")
        i = i+1
    }
    
    @objc fileprivate func bump(){
        print("Bump!")
    }
    
    @objc fileprivate func startLoading(){
        NotificationManager.shared.displayLoadingMessage("Loading...", completionHandler: { (notification) in
            self.notificationCompletion = notification
        })
    }
    
    @objc fileprivate func stopLoading(){
        if let myNotificationCompletion = notificationCompletion{
            myNotificationCompletion()
            notificationCompletion = nil
        }
    }
}
