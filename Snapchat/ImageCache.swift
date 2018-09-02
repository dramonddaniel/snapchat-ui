//
//  ImageCache.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        imageUrlString = urlString
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        self.image = nil
        
        guard let url = URL(string: urlString) else { print("ERROR LOADING IMAGE URL"); return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil { return }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    if self.imageUrlString == urlString {
                        if self.imageUrlString != "" {
                            self.image = downloadedImage
                        } else {
                            self.image = nil
                        }
                    }
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                }
            }
            
        }).resume()
    }
}
