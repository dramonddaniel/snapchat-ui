//
//  ChatController+Handlers.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/08/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

extension ChatController {
    
    @objc func handleBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
