//
//  CameraButton.swift
//  Snapchat
//
//  Created by Danny Dramond on 26/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

public protocol CameraButtonDelegate: class {
    func buttonWasTapped()
    func buttonDidBeginLongPress()
    func buttonDidEndLongPress()
    func longPressDidReachMaximumDuration()
    func setMaxiumVideoDuration() -> Double
}

open class CameraButton: UIButton {
    
    public weak var delegate: CameraButtonDelegate?
    
    fileprivate var timer : Timer?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createGestureRecognizers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createGestureRecognizers()
    }
    
    @objc fileprivate func Tap() {
        delegate?.buttonWasTapped()
    }
    
    @objc fileprivate func LongPress(_ sender:UILongPressGestureRecognizer!)  {
        switch sender.state {
        case .began:
            delegate?.buttonDidBeginLongPress()
            startTimer()
        case .ended:
            invalidateTimer()
            delegate?.buttonDidEndLongPress()
        default:
            break
        }
    }
    
    @objc fileprivate func timerFinished() {
        invalidateTimer()
        delegate?.longPressDidReachMaximumDuration()
    }
    
    fileprivate func startTimer() {
        if let duration = delegate?.setMaxiumVideoDuration() {
            if duration != 0.0 && duration > 0.0 {
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector:  #selector(CameraButton.timerFinished), userInfo: nil, repeats: false)
            }
        }
    }
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func createGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraButton.Tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(CameraButton.LongPress))
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longGesture)
    }
    
}
