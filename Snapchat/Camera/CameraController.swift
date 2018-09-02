//
//  CameraController.swift
//  Snapchat
//
//  Created by Danny Dramond on 19/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit
import CoreLocation

class CameraController: CameraViewController, CameraViewControllerDelegate {
    
    let locationManager = CLLocationManager()
    var currentUserCoordinate: CLLocation?
    
    var captureButton: CameraRecordButton!
    
    let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let bitMoji: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bitmoji")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let navigationChatLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 0.15
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        return label
    }()
    
    lazy var flipButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "camera_flip")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraSwitchAction(_:))))
        return iv
    }()
    
    lazy var flashButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "camera_flashoff")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFlashAction(_:))))
        return iv
    }()
    
    lazy var feedButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "feed")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFlashAction(_:))))
        return iv
    }()
    
    lazy var camerarollButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "cameraroll")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFlashAction(_:))))
        return iv
    }()
    
    lazy var storyButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "story")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFlashAction(_:))))
        return iv
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 0.20)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        addButtons()
        
        setupViews()
        
        if CLLocationManager.locationServicesEnabled() {
            self.handleUpdateLocation()
        } else {
            return
        }
        
        view.backgroundColor = .black
        UIApplication.shared.keyWindow?.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func handleUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupViews() {
        view.addSubview(navigationBarView)
        _ = navigationBarView.anchor(view.topAnchor, view.rightAnchor, nil, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 50 + 20)
        
        navigationBarView.addSubview(bitMoji)
        _ = bitMoji.anchor(nil, nil, nil, navigationBarView.leftAnchor, 0, 0, 0, 12, width: 28, height: 28)
        bitMoji.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor, constant: 10).isActive = true
        
        navigationBarView.addSubview(searchButton)
        _ = searchButton.anchor(nil, nil, nil, bitMoji.rightAnchor, 0, 0, 0, 8, width: 27, height: 27)
        searchButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor, constant: 11.5).isActive = true
        
        navigationBarView.addSubview(navigationChatLabel)
        _ = navigationChatLabel.anchor(navigationBarView.topAnchor, navigationBarView.rightAnchor, navigationBarView.bottomAnchor, searchButton.rightAnchor, 20, 0, 0, 4, width: 0, height: 0)
        
        navigationBarView.addSubview(flipButton)
        _ = flipButton.anchor(nil, navigationBarView.rightAnchor, nil, nil, 0, 16, 0, 0, width: 25, height: 25)
        flipButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor, constant: 10).isActive = true
        
        navigationBarView.addSubview(flashButton)
        _ = flashButton.anchor(nil, flipButton.leftAnchor, nil, nil, 0, 16, 0, 0, width: 17, height: 17)
        flashButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor, constant: 10).isActive = true
        
        navigationBarView.addSubview(seperatorView)
        _ = seperatorView.anchor(nil, navigationBarView.rightAnchor, navigationBarView.bottomAnchor, navigationBarView.leftAnchor, 0, 0, 0, 0, width: 0, height: 0.50)
        
        self.view.addSubview(feedButton)
        _ = feedButton.anchor(nil, nil, view.bottomAnchor, view.leftAnchor, 0, 0, 25, 25, width: 20, height: 20)
        
        self.view.addSubview(storyButton)
        _ = storyButton.anchor(nil, view.rightAnchor, view.bottomAnchor, nil, 0, 25, 25, 0, width: 22, height: 22)
        
        self.view.addSubview(camerarollButton)
        _ = camerarollButton.anchor(nil, nil, view.bottomAnchor, nil, 0, 0, 20, 0, width: 24, height: 24)
        self.camerarollButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func camera(_ camera: CameraViewController, didTake photo: UIImage) {
        let photoViewController = PhotoViewController(image: photo)
        let navigationPhotoViewController = UINavigationController(rootViewController: photoViewController)
        self.present(navigationPhotoViewController, animated: false, completion: nil)
    }
     
     func camera(_ camera: CameraViewController, didBeginRecordingVideo cam: CameraViewController.CameraSelection) {
             print("Did Begin Recording")
             captureButton.growButton()
             UIView.animate(withDuration: 0.20, animations: {
                self.navigationBarView.alpha = 0
         })
     }
     
     func camera(_ camera: CameraViewController, didFinishRecordingVideo cam: CameraViewController.CameraSelection) {
             print("Did Finish Recording")
             captureButton.shrinkButton()
             UIView.animate(withDuration: 0.25, animations: {
                self.navigationBarView.alpha = 1
         })
     }
     
     func camera(_ camera: CameraViewController, didFinishProcessVideoAt url: URL) {
        let videoViewController = VideoViewController(videoURL: url)
        videoViewController.currentUserCoordinate = self.currentUserCoordinate
        self.present(videoViewController, animated: false, completion: nil)
     }
    
    func camera(_ camera: CameraViewController, didFocusAtPoint point: CGPoint) {
        let image = UIImage(named: "focus")?.withRenderingMode(.alwaysOriginal)
        let focusView = UIImageView(image: image)
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func camera(_ camera: CameraViewController, didChangeZoomLevel zoom: CGFloat) {
        
    }
    
    func camera(_ camera: CameraViewController, didSwitchCameras cam: CameraViewController.CameraSelection) {
        
    }
    
    @objc private func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    
    @objc private func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.tintColor = UIColor(red: 233/255, green: 89/255, blue: 80/255, alpha: 1.0)
        } else {
            flashButton.tintColor = .white
        }
    }
    
    private func addButtons() {
        captureButton = CameraRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 160, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.delegate = self
    }
}

extension CameraController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.currentUserCoordinate = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
