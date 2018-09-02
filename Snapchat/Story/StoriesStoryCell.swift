//
//  StoriesStoryCell.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/08/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class StoriesStoryCell: BaseCell {
    
    var story: Story? {
        didSet {
            guard let username = self.story?.username, let image_url = self.story?.image_url, let bitmoji_name = self.story?.bitmoji_image_name else { return }
            
            self.imageView.loadImageUsingCacheWithUrlString(image_url)
            self.nameLabel.text = username
            self.bitmojiImageView.image = UIImage(named: bitmoji_name)?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    let blackOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.25, alpha: 0.35)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let bitmojiImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 17.5
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    override func setupViews() {
        
        self.backgroundColor = .white
        
        self.addSubview(imageView)
        _ = imageView.anchor(self.topAnchor, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
        
        self.addSubview(blackOverlay)
        _ = blackOverlay.anchor(self.topAnchor, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
        
        self.addSubview(nameLabel)
        _ = nameLabel.anchor(nil, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 8, 12, 8, width: 0, height: 0)
        
        self.addSubview(bitmojiImageView)
        _ = bitmojiImageView.anchor(nil, nil, nameLabel.topAnchor, nil, 0, 0, 12, 0, width: 35, height: 35)
        bitmojiImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
}
