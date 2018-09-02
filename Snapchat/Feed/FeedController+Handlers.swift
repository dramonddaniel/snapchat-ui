//
//  FeedController+Handlers.swift
//  Snapchat
//
//  Created by Danny Dramond on 26/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

extension FeedController {
    
    func handlePresentCustomAlert() {
        self.snapchatPopUp.setupCustomAlertView(view: self.view) {
            let windowViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAnimateDismiss))
            self.snapchatPopUp.windowView.addGestureRecognizer(windowViewTap)
            self.snapchatPopUp.actionButton.addTarget(self, action: #selector(self.handleAnimateDismiss), for: .touchUpInside)
            self.snapchatPopUp.cancelButton.addTarget(self, action: #selector(self.handleAnimateDismiss), for: .touchUpInside)
            self.snapchatPopUp.animateCustomAlert(view: self.view, {
                self.view.endEditing(true)
            })
        }
    }
    
    @objc func handleAnimateDismiss() {
        self.snapchatPopUp.animateCustomAlertDismiss(view: self.view)
    }
    
}
