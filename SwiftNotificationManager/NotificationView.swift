//
//  NotificationView.swift
//  Repnote
//
//  Created by Jonathan Neumann on 31/08/2017.
//  Copyright © 2017 Audioy. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    static let margin: CGFloat = 8
    
    init(message: String){
        super.init(frame: .zero)
        messageLabel.text = message
        backgroundColor = UIColor.random
        addSubviewsAndSetupContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI
    fileprivate lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = UIColor.darkGray
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
}

extension NotificationView{
    func addSubviewsAndSetupContraints() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: NotificationView.margin),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: NotificationView.margin),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -NotificationView.margin),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -NotificationView.margin)
            ])
    }
}
