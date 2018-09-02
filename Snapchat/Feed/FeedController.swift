//
//  FeedController.swift
//  Snapchat
//
//  Created by Danny Dramond on 19/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class FeedController: UIViewController {
    
    var mainController: MainController? = nil
    
    var snaps: [Snap] = []
    
    var topViewAlphaValue: CGFloat = 0.0
    var navigationElementsAlphaValue: CGFloat = 0.0
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    let navigationGradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .lightBlue()
        
        DispatchQueue.global(qos: .userInitiated).sync {
            Service.sharedInstance.handleFetchPosts { (snaps) in
                guard let data = snaps else { return }
                self.snaps = data
                
                self.snaps.sort(by: { (snap1, snap2) -> Bool in
                    return snap1.timestamp!.doubleValue > snap2.timestamp!.doubleValue
                })
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        self.handlePresentCustomAlert()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainController?.scrollView.isScrollEnabled = true
    }
    
    lazy var snapchatPopUp: SnapchatPopUp = {
        let view = SnapchatPopUp()
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let bitMoji: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bitmoji")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let navigationChatLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 0.10
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        return label
    }()
    
    let addButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        return cv
    }()
    
    func setupViews() {
        self.collectionView.register(SnapCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        _ = collectionView.anchor(view.topAnchor, view.rightAnchor, view.bottomAnchor, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 0)
        
        view.addSubview(topView)
        _ = topView.anchor(view.topAnchor, view.rightAnchor, nil, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 50 + 20)
        
        navigationGradientLayer.colors = [UIColor.lightBlue().cgColor, UIColor.darkBlue().cgColor]
        navigationGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        navigationGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        navigationGradientLayer.locations = [0.0, 1.0]
        topView.layer.addSublayer(navigationGradientLayer)
        navigationGradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + 20)
        
        view.addSubview(navigationBarView)
        _ = navigationBarView.anchor(view.topAnchor, view.rightAnchor, nil, view.leftAnchor, 0, 0, 0, 0, width: 0, height: 50 + 20)
        
        let blackColor: UIColor = UIColor(white: 0.25, alpha: 0.15)
        gradientLayer.colors = [blackColor.cgColor, UIColor.clear.cgColor]
        navigationBarView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + 20)
        
        navigationBarView.addSubview(bitMoji)
        _ = bitMoji.anchor(nil, nil, nil, navigationBarView.leftAnchor, 0, 0, 0, 12, width: 28, height: 28)
        bitMoji.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor, constant: 10).isActive = true
        
        navigationBarView.addSubview(searchButton)
        _ = searchButton.anchor(nil, nil, nil, bitMoji.rightAnchor, 0, 0, 0, 8, width: 27, height: 27)
        searchButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor, constant: 11.5).isActive = true
        
        navigationBarView.addSubview(navigationChatLabel)
        _ = navigationChatLabel.anchor(navigationBarView.topAnchor, navigationBarView.rightAnchor, navigationBarView.bottomAnchor, searchButton.rightAnchor, 20, 0, 0, 4, width: 0, height: 0)
        
        navigationBarView.addSubview(addButton)
        _ = addButton.anchor(nil, navigationBarView.rightAnchor, nil, nil, 0, 12, 0, 0, width: 25, height: 25)
        addButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor, constant: 10).isActive = true
    }
}

extension FeedController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snap = snaps[indexPath.item]
        guard let type = snap.type else { return }
        
        switch type {
        case "image":
            let snapController = SnapController()
            snapController.snap = snap
            self.mainController?.scrollView.isScrollEnabled = false
            self.navigationController?.pushViewController(snapController, animated: false)
        case "chat":
            let chatController = ChatController()
            chatController.snap = snap
            self.mainController?.scrollView.isScrollEnabled = false
            self.navigationController?.pushViewController(chatController, animated: true)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.snaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SnapCell
        
        if indexPath.item == 0 {
            cell.isFirstCell = true
        } else {
            cell.isFirstCell = false
        }
        
        cell.index = indexPath.item
        cell.snap = self.snaps[indexPath.item]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + 50 + 20 /* ADD NAV BAR AND STATUS BAR HEIGHT */
        guard let view = scrollView.superview else { return }
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        
        if translation.y > 0 { /* DOWN */
            
            self.topViewAlphaValue = 1.0 + (yOffset / 100)
            self.topView.alpha = self.topViewAlphaValue
            
            self.navigationElementsAlphaValue = 1.0 + (yOffset / 100)
            self.searchButton.alpha = self.navigationElementsAlphaValue
            self.navigationChatLabel.alpha = self.navigationElementsAlphaValue
            self.bitMoji.alpha = self.navigationElementsAlphaValue
            self.addButton.alpha = self.navigationElementsAlphaValue
            
        } else { /* UP */
            
            self.topViewAlphaValue = 1.0 - (yOffset / 100)
            self.topView.alpha = self.topViewAlphaValue
            
            self.navigationElementsAlphaValue = 1.0 - (yOffset / 100)
        }
    }
    
}
