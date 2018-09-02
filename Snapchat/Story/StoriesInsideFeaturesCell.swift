//
//  StoriesInsideFeaturesCell.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class StoriesInsideFeaturedCell: UICollectionViewCell {
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    var featured: Featured? {
        didSet {
            guard let image_url = self.featured?.urlToImage,
            let title = self.featured?.title else { return }
            
            self.imageView.loadImageUsingCacheWithUrlString(image_url)
            self.titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    
    lazy var imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 6
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
        return iv
    }()
    
    @objc func handleTapped() {
        guard let urlToArticle = self.featured?.url else { return }
        guard let url = URL(string: urlToArticle) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    func setupViews() {
        self.addSubview(imageView)
        _ = imageView.anchor(self.topAnchor, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
        
        let blackColor: UIColor = UIColor(white: 0, alpha: 0.75)
        gradientLayer.colors = [UIColor.clear.cgColor, blackColor.cgColor]
        imageView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2)
        
        self.addSubview(titleLabel)
        _ = titleLabel.anchor(nil, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 6, 6, 6, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
