//
//  ViewController.swift
//  Snapchat
//
//  Created by Danny Dramond on 19/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.alwaysBounceVertical = false
        sv.alwaysBounceHorizontal = false
        sv.isPagingEnabled = true
        sv.delegate = self
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.isScrollEnabled = true
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .lightBlue()
        
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViews() {
        
        // MARK: - HOME CONTROLLER
        
        let feedController = FeedController()
        feedController.mainController = self
        let navigationFeedController = UINavigationController(rootViewController: feedController)
        self.addChildViewController(navigationFeedController)
        self.scrollView.addSubview(navigationFeedController.view)
        navigationFeedController.didMove(toParentViewController: self)
        navigationFeedController.view.frame = scrollView.bounds
        
        // MARK: - CHAT CONTROLLER
        
        let cameraController = CameraController()
        let navigationCameraController = UINavigationController(rootViewController: cameraController)
        self.addChildViewController(navigationCameraController)
        self.scrollView.addSubview(navigationCameraController.view)
        navigationCameraController.didMove(toParentViewController: self)
        navigationCameraController.view.frame = scrollView.bounds
        
        var chatControllerFrame: CGRect = navigationCameraController.view.frame
        chatControllerFrame.origin.x = self.view.frame.width
        navigationCameraController.view.frame = chatControllerFrame
        
        // MARK: - CAMERA CONTROLLER
        
        let storiesController = StoriesController()
        storiesController.mainController = self
        let navigationStoriesController = UINavigationController(rootViewController: storiesController)
        self.addChildViewController(navigationStoriesController)
        self.scrollView.addSubview(navigationStoriesController.view)
        navigationStoriesController.didMove(toParentViewController: self)
        navigationStoriesController.view.frame = scrollView.bounds
        
        var cameraControllerFrame: CGRect = navigationStoriesController.view.frame
        cameraControllerFrame.origin.x = 2 * self.view.frame.width
        navigationStoriesController.view.frame = cameraControllerFrame
        
        self.scrollView.contentSize = CGSize(width: (self.view.frame.size.width) * 3, height: self.view.frame.size.height)
        self.scrollView.contentOffset = CGPoint(x: (-self.view.frame.width), y: self.view.frame.height)
        
        view.addSubview(scrollView)
        _ = scrollView.anchor(view.topAnchor, view.rightAnchor, view.bottomAnchor, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
    }
}

extension MainController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentPage = scrollView.contentOffset.x / self.view.frame.width
        
        if currentPage > 1.0 {
            self.view.backgroundColor = .darkPurple()
        } else if currentPage < 1.0 {
            self.view.backgroundColor = .lightBlue()
        }
        
        guard let view = scrollView.superview else { return }
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        
//        let x: CGFloat = abs(translation.x)
        
        if translation.x > 0 { /* LEFT */
            
//            print("LEFT")
            
        } else { /* RIGHT */
            
//            print("RIGHT")
            
        }
    }
}

