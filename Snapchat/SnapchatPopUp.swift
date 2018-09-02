//
//  SnapchatPopUp.swift
//  Snapchat
//
//  Created by Danny Dramond on 23/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class SnapchatPopUp: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        backgroundColor = .white
        
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.12
    }
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.50)
        view.alpha = 0
        return view
    }()
    
    let windowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        view.alpha = 0
        return view
    }()
    
    let titleText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Medium", size: 17.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Contact Info:\ndramonddaniel@gmail.com"
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 242/255, green: 60/255, blue: 87/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Got It", for: .normal)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 11)
        let color = UIColor(white: 0.75, alpha: 1.0)
        button.setTitleColor(color, for: .normal)
        button.setTitle("CANCEL", for: .normal)
        return button
    }()
    
    var viewStartingAnchor: NSLayoutConstraint?
    var viewCenterYAnchor: NSLayoutConstraint?
    
    func setupViews() {
        addSubview(cancelButton)
        addSubview(actionButton)
        addSubview(titleText)
        
        _ = cancelButton.anchor(nil, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 0, width: 0, height: 40)
        _ = actionButton.anchor(nil, nil, cancelButton.topAnchor, nil, 0, 0, 0, 0, width: 175, height: 42)
        self.actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        _ = titleText.anchor(self.topAnchor, self.rightAnchor, actionButton.topAnchor, self.leftAnchor, 0, 20, 0, 20, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SnapchatPopUp {
    
    func setupCustomAlertView(view: UIView, _ completion: (() -> Swift.Void)? = nil) {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        window.addSubview(windowView)
        windowView.frame = window.bounds
        window.addSubview(self)
        
        viewStartingAnchor = self.topAnchor.constraint(equalTo: window.bottomAnchor)
        viewStartingAnchor?.isActive = true
        
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        _ = self.anchor(nil, nil, nil, nil, 0, 0, 0, 0, width: 280, height: 170)
        self.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        
        view.layoutIfNeeded()
        
        completion?()
    }
    
    func animateCustomAlert(view: UIView, _ completion: (() -> Swift.Void)? = nil) {
        
        self.viewStartingAnchor?.isActive = false
        
        self.viewCenterYAnchor = self.centerYAnchor.constraint(equalTo: (window?.centerYAnchor)!)
        self.viewCenterYAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.25, delay: 0.25, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            
            self.alpha = 1
            self.windowView.alpha = 1
            self.statusBarView.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            view.layoutIfNeeded()
            
        }) { (completed) in
            
            completion?()
        }
    }
    
    func animateCustomAlertDismiss(view: UIView, _ completion: (() -> Swift.Void)? = nil) {
        
        self.viewStartingAnchor?.isActive = true
        self.viewCenterYAnchor?.isActive = false
        
        UIView.animate(withDuration: 0.25, delay: 0.25, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            
            self.alpha = 0
            self.windowView.alpha = 0
            self.statusBarView.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            self.window?.layoutIfNeeded()
            
        }) { (completed) in
            
            self.removeFromSuperview()
            
            completion?()
        }
    }
}
