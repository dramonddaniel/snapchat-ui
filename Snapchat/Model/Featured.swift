//
//  Featured.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class Featured: NSObject {
    var author: String?
    var title: String?
    var desc: String?
    var url: String?
    var urlToImage: String?
    var published: String?
    
    init(author: String?, title: String?, desc: String?, url: String?, urlToImage: String?, published: String?) {
        self.author = author
        self.title = title
        self.desc = desc
        self.url = url
        self.urlToImage = urlToImage
        self.published = published
    }
}
