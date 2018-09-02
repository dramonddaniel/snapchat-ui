//
//  StoriesFeaturedCell.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class StoriesFeaturedCell: UICollectionViewCell {
    
    var featured: [Featured] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let layout = collectionView.collectionViewLayout as? PinterestLayout else { return }
        layout.delegate = self
        
        setupViews()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceVertical = false
        cv.alwaysBounceHorizontal = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsetsMake(-5, 10, 10, 10)
        return cv
    }()
    
    func setupViews() {
        self.backgroundColor = .white
        
        self.collectionView.register(StoriesInsideFeaturedCell.self, forCellWithReuseIdentifier: cellId)
        
        self.addSubview(collectionView)
        _ = collectionView.anchor(self.topAnchor, self.rightAnchor, self.bottomAnchor, self.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoriesFeaturedCell: UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let heightArray: [CGFloat] = [200, 270, 320]
        let randomIndex = Int(arc4random_uniform(UInt32(heightArray.count)))
        return heightArray[randomIndex]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.featured.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StoriesInsideFeaturedCell
        
        cell.featured = self.featured[indexPath.item]
        
        return cell
    }
    
}
