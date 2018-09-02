//
//  PhotoViewController.swift
//  Snapchat
//
//  Created by Danny Dramond on 26/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoViewController: UIViewController {
    
    var currentUserCoordinate: CLLocation?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var backgroundImage: UIImage
    
    init(image: UIImage) {
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        return iv
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "done_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        view.addSubview(imageView)
        _ = imageView.anchor(view.topAnchor, view.rightAnchor, view.bottomAnchor, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
        
        self.imageView.image = self.backgroundImage
        
        view.addSubview(backButton)
        _ = backButton.anchor(view.topAnchor, nil, nil, view.leftAnchor, 12, 0, 0, 12, width: 50, height: 50)
        
        view.addSubview(doneButton)
        _ = doneButton.anchor(nil, view.rightAnchor, view.bottomAnchor, nil, 0, 12, 12, 0, width: 50, height: 50)
    }
    
    @objc func cancel() {
        self.dismiss(animated: false, completion: nil)
    }
}

