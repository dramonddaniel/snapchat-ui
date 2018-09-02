//
//  SnapController+Handlers.swift
//  Snapchat
//
//  Created by Danny Dramond on 02/09/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

extension SnapController {
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
}
