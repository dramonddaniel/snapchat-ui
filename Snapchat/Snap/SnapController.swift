//
//  SnapController.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/08/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class SnapController: UIViewController {
    
    var snap: Snap? {
        didSet {
            guard let content = self.snap?.content else { return }
            self.contentImageView.image = UIImage(named: content)?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .green
        
        setupViews()
    }
    
    lazy var contentImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        iv.addGestureRecognizer(gesture)
        return iv
    }()
    
    let menuButton: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "dot_menu")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    func setupViews() {
        
        self.view.addSubview(contentImageView)
        _ = contentImageView.anchor(view.topAnchor, view.rightAnchor, view.bottomAnchor, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
        
        self.view.addSubview(menuButton)
        _ = menuButton.anchor(view.topAnchor, view.rightAnchor, nil, nil, 20 + 17.5, 12, 0, 0, width: 18, height: 18)
        self.menuButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
}
