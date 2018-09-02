//
//  StoriesHeaderCell.swift
//  Snapchat
//
//  Created by Danny Dramond on 27/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class StoriesHeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 16)
        label.textColor = UIColor(red: 185/255, green: 96/255, blue: 254/255, alpha: 1.0)
        return label
    }()
    
    func setupViews() {
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        _ = titleLabel.anchor(self.topAnchor, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 10, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
