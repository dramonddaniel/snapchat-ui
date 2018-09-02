//
//  Helpers.swift
//  Snapchat
//
//  Created by Danny Dramond on 19/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        if secondsAgo < 60 {
            return "Just now"
        } else if secondsAgo < 120 {
            return "\(secondsAgo / 60)m ago"
        } else if secondsAgo < 60 * 60 {
            return "\(secondsAgo / 60)m ago"
        } else if secondsAgo < 60 * 60 * 2 {
            return "\(secondsAgo / 60 / 60)h ago"
        } else if secondsAgo < 60 * 60 * 24 {
            return "\(secondsAgo / 60 / 60)h ago"
        } else if secondsAgo < 60 * 60 * 24 * 2 {
            return "\(secondsAgo / 60 / 60 / 24)d ago"
        } else if secondsAgo < 60 * 60 * 24 * 7 {
            return "\(secondsAgo / 60 / 60 / 24)d ago"
        } else if secondsAgo < 60 * 60 * 24 * 7 * 2 {
            return "\(secondsAgo / 60 / 60 / 24 / 7)w ago"
        } else if secondsAgo < 60 * 60 * 24 * 7 * 4 {
            return "\(secondsAgo / 60 / 60 / 24 / 7)w ago"
        }
        
        return "\(secondsAgo / 60 / 60 / 24 / 7)w ago"
    }
}

extension UIColor {
    
    static func lightBlue() -> UIColor {
        return UIColor(red: 46/255, green: 200/255, blue: 255/255, alpha: 1.0)
    }
    
    static func darkBlue() -> UIColor {
        return UIColor(red: 30/255, green: 166/255, blue: 236/255, alpha: 0.75)
    }
    
    static func lightPurple() -> UIColor {
        return UIColor(red: 185/255, green: 96/255, blue: 254/255, alpha: 1.0)
    }
    
    static func darkPurple() -> UIColor {
        return UIColor(red: 150/255, green: 62/255, blue: 204/255, alpha: 1.0)
    }
}

extension UIView {
    
    func centerXY(_ view: UIView, x: CGFloat, y: CGFloat, _ centerX: NSLayoutXAxisAnchor? = nil, _ centerY: NSLayoutYAxisAnchor? = nil) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        
        if let centerX = centerX { anchors.append(centerX.constraint(equalTo: view.centerXAnchor, constant: x)) }
        if let centerY = centerY { anchors.append(centerY.constraint(equalTo: view.centerYAnchor, constant: y)) }
        
        anchors.forEach({$0.isActive = true})

        return anchors
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, _ right: NSLayoutXAxisAnchor? = nil, _ bottom: NSLayoutYAxisAnchor? = nil, _ left: NSLayoutXAxisAnchor? = nil, _ topConstant: CGFloat = 0, _ rightConstant: CGFloat = 0, _ bottomConstant: CGFloat = 0, _ leftConstant: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        
        if let top = top { anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant)) }
        if let right = right { anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant)) }
        if let bottom = bottom { anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)) }
        if let left = left { anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant)) }
        if width > 0 { anchors.append(widthAnchor.constraint(equalToConstant: width)) }
        if height > 0 { anchors.append(heightAnchor.constraint(equalToConstant: height)) }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}
