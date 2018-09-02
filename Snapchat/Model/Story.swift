//
//  Story.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/08/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class Story: NSObject {
    
    var username: String?
    var type: String?
    var bitmoji_image_name: String?
    var image_url: String?
    
    init(username: String?, type: String?, bitmoji_image_name: String?, image_url: String?) {
        self.username = username
        self.type = type
        self.bitmoji_image_name = bitmoji_image_name
        self.image_url = image_url
    }
}
