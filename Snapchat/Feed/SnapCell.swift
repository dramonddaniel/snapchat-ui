//
//  SnapCell.swift
//  Snapchat
//
//  Created by Danny Dramond on 20/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

class SnapCell: UICollectionViewCell {
    
    var index: Int = 0
    
    var isFirstCell: Bool = false {
        didSet {
            self.backgroundColor = .clear
            self.cellBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))

            if self.isFirstCell == true {
                self.cellBackgroundView.layer.cornerRadius = 2.0

                let maskPath = UIBezierPath(roundedRect: self.cellBackgroundView.bounds,
                                            byRoundingCorners: [.topLeft, .topRight],
                                            cornerRadii: CGSize(width: 18.0, height: 0.0))

                let maskLayer = CAShapeLayer()
                maskLayer.path = maskPath.cgPath
                self.cellBackgroundView.layer.mask = maskLayer
            }

            self.cellBackgroundView.backgroundColor = .white
            self.addSubview(cellBackgroundView)
            
            self.addSubview(bitmojiImageView)
            _ = bitmojiImageView.anchor(nil, nil, nil, self.leftAnchor, 0, 0, 0, 4, width: 50, height: 50)
            bitmojiImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            self.addSubview(streakLabel)
            _ = streakLabel.anchor(self.topAnchor, self.rightAnchor, self.bottomAnchor, nil, 0, 12, 0, 0, width: 0, height: 0)

            self.addSubview(usernameLabel)
            _ = usernameLabel.anchor(bitmojiImageView.topAnchor, nil, nil, bitmojiImageView.rightAnchor, 5 + 4, 0, 0, 4, width: 0, height: 20)
            
            self.addSubview(typeImageView)
            _ = typeImageView.anchor(nil, nil, bitmojiImageView.bottomAnchor, bitmojiImageView.rightAnchor, 0, 0, 4, 8, width: 12, height: 12)

            self.addSubview(infoLabel)
            _ = infoLabel.anchor(nil, nil, bitmojiImageView.bottomAnchor, typeImageView.rightAnchor, 0, 0, 5 - 5, 6, width: 0, height: 20)
            
            self.addSubview(seperatorView)
            _ = seperatorView.anchor(nil, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 0, width: 0, height: 0.50)
        }
    }
    
    var cellBackgroundView: UIView!
    
    var snap: Snap? {
        didSet {
            
            guard let username = self.snap?.username, let type = snap?.type, let is_read = snap?.isRead, let timestamp = snap?.timestamp as? TimeInterval, let bitmoji = self.snap?.bitmoji else { return }
            
            self.usernameLabel.text = username
            self.bitmojiImageView.image = UIImage(named: bitmoji)?.withRenderingMode(.alwaysOriginal)
            
            self.streakLabel.text = getRandomEmoji()
            
            let date = Date(timeIntervalSince1970: timestamp)
            let time = date.timeAgoDisplay()

            if type == "chat" && is_read == true {
                self.typeImageView.image = UIImage(named: "opened_chat")
                self.usernameLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
                self.infoLabel.text = "Opened - \(time)"
            } else if type == "chat" && is_read == false {
                self.typeImageView.image = UIImage(named: "unopened_chat")
                self.usernameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
                self.infoLabel.text = "Received - \(time)"
            }

            if type == "image" && is_read == true {
                self.typeImageView.image = UIImage(named: "opened_snap")
                self.usernameLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
                self.infoLabel.text = "Received - \(time)"
            } else if type == "image" && is_read == false {
                self.typeImageView.image = UIImage(named: "unopened_snap")
                self.usernameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
                self.infoLabel.text = "Received - \(time)"
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func getRandomEmoji() -> String {
        let emojis: [String] = ["💛", "🔥", "😎", "💫", "💥", "🤓"]
        let index = Int(arc4random_uniform(UInt32(emojis.count)))
        return emojis[index]
    }
    
    let bitmojiImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        iv.layer.cornerRadius = 25
        return iv
    }()
    
    let typeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 12)
        label.textColor = UIColor(white: 0.75, alpha: 1.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var streakLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 0.20)
        return view
    }()
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
