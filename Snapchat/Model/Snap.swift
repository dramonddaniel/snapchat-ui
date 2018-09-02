//
//  Snap.swift
//  Snapchat
//
//  Created by Danny Dramond on 20/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class Snap: NSObject {
    
    var username: String?
    var timestamp: NSNumber?
    var type: String?
    var bitmoji: String?
    var isRead: Bool?
    var content: String?
    
    init(username: String?, timestamp: NSNumber?, type: String?, bitmoji: String?, isRead: Bool?, content: String?) {
        self.username = username
        self.timestamp = timestamp
        self.type = type
        self.bitmoji = bitmoji
        self.isRead = isRead
        self.content = content
    }
}
