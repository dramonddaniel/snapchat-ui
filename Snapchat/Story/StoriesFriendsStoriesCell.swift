//
//  StoriesSponsoredCell.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class StoriesFriendsStoriesCell: UICollectionViewCell {
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    var stories = [Story]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        return cv
    }()
    
    func setupViews() {
        
        self.collectionView.register(StoriesStoryCell.self, forCellWithReuseIdentifier: cellId)
        
        self.addSubview(collectionView)
        _ = collectionView.anchor(self.topAnchor, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoriesFriendsStoriesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width / 5), height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StoriesStoryCell
        
        cell.story = self.stories[indexPath.item]
        
        return cell
    }
}
