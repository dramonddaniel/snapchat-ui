//
//  CameraViewControllerDelegate.swift
//  Snapchat
//
//  Created by Danny Dramond on 26/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

public protocol CameraViewControllerDelegate: class {
    func camera(_ camera: CameraViewController, didTake photo: UIImage)
    func camera(_ camera: CameraViewController, didBeginRecordingVideo cam: CameraViewController.CameraSelection)
    func camera(_ camera: CameraViewController, didFinishRecordingVideo cam: CameraViewController.CameraSelection)
    func camera(_ camera: CameraViewController, didFinishProcessVideoAt url: URL)
    func camera(_ camera: CameraViewController, didFailToRecordVideo error: Error)
    func camera(_ camera: CameraViewController, didSwitchCameras cam: CameraViewController.CameraSelection)
    func camera(_ camera: CameraViewController, didFocusAtPoint point: CGPoint)
    func camera(_ camera: CameraViewController, didChangeZoomLevel zoom: CGFloat)
}

public extension CameraViewControllerDelegate {
    
    func camera(_ camera: CameraViewController, didTake photo: UIImage) {
        
    }
    
    
    func camera(_ camera: CameraViewController, didBeginRecordingVideo cam: CameraViewController.CameraSelection) {
        
    }
    
    
    func camera(_ camera: CameraViewController, didFinishRecordingVideo cam: CameraViewController.CameraSelection) {
        
    }
    
    
    func camera(_ camera: CameraViewController, didFinishProcessVideoAt url: URL) {
        
    }
    
    func camera(_ camera: CameraViewController, didFailToRecordVideo error: Error) {
        
    }
    
    func camera(_ camera: CameraViewController, didSwitchCameras cam: CameraViewController.CameraSelection) {
        
    }
    
    
    func camera(_ camera: CameraViewController, didFocusAtPoint point: CGPoint) {
        
    }
    
    
    func camera(_ camera: CameraViewController, didChangeZoomLevel zoom: CGFloat) {
        
    }
}
