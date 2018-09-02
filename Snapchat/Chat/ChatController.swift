//
//  ChatController.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/08/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class ChatController: UIViewController {
    
    var snap: Snap? {
        didSet {
            guard let username = snap?.username else { return }
            self.navigationTitleLabel.text = username
        }
    }
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.textColor = .white
        label.layer.masksToBounds = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBack(_:)), for: .touchUpInside)
        return button
    }()
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupViews()
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    let navigationGradientLayer: CAGradientLayer = CAGradientLayer()
    
    func setupViews() {
        
        view.addSubview(topView)
        _ = topView.anchor(view.topAnchor, view.rightAnchor, nil, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 50 + 20)
        
        let lightBlue: UIColor = UIColor(red: 46/255, green: 200/255, blue: 255/255, alpha: 1.0)
        let darkBlue: UIColor = UIColor(red: 30/255, green: 166/255, blue: 236/255, alpha: 0.75)
        
        navigationGradientLayer.colors = [lightBlue.cgColor, darkBlue.cgColor]
        navigationGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        navigationGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        navigationGradientLayer.locations = [0.0, 1.0]
        topView.layer.addSublayer(navigationGradientLayer)
        navigationGradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + 20)
        
        view.addSubview(navigationBarView)
        _ = navigationBarView.anchor(view.topAnchor, view.rightAnchor, nil, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 50 + 20)
        
        let blackColor: UIColor = UIColor(white: 0.25, alpha: 0.15)
        gradientLayer.colors = [blackColor.cgColor, UIColor.clear.cgColor]
        navigationBarView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + 20)
        
        view.addSubview(navigationTitleLabel)
        _ = navigationTitleLabel.anchor(topView.topAnchor, nil, topView.bottomAnchor, nil, 20, 0, 0, 0, width: 0, height: 0)
        navigationTitleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        
        view.addSubview(backButton)
        _ = backButton.anchor(topView.topAnchor, topView.rightAnchor, nil, nil, 20 + 17.5, 12, 0, 0, width: 15, height: 15)
        self.backButton.transform = CGAffineTransform(rotationAngle: .pi)
        
        view.addSubview(menuButton)
        _ = menuButton.anchor(topView.topAnchor, nil, nil, topView.leftAnchor, 20 + 16, 0, 0, 12, width: 18, height: 18)
    }
}
