//
//  ProfileVlogOverviewViewController.swift
//  Swabbr
//
//  Created by James Bal on 02-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// TODO: refactor
// swiftlint:disable force_cast

import Foundation
import UIKit

class ProfileCollectionOverviewViewController: UIViewController, BaseViewProtocol {
    
    private var collectionView: UICollectionView!
    
    private enum DataType {
        case following
        case followers
        case vlogs
    }
    
    private let type: DataType
    
    private let controllerService = ProfileCollectionOverviewControllerService()
    
    /**
     Initialize the view controller this way if we want to get the vlogs thats associated to the given user id.
     - parameter userId: An int value representing an user id.
    */
    init(vlogOwnerId: String) {
        type = DataType.vlogs
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getVlogs(userId: vlogOwnerId)
    }
    
    /**
     Initialize the view controller this way if we want to get the users that the user with this id is currently following.
     - parameter userId: An int value representing an user id.
     */
    init(followingOwnerId: String) {
        type = DataType.following
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     Initialize the view controller this way if we want to get the users who is currently following the user with this id.
     - parameter userId: An int value representing an user id.
     */
    init(followersOwnerId: String) {
        type = DataType.followers
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getFollowers(userId: followersOwnerId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
        
    }
    
    internal func initElements() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        if type == DataType.vlogs {
            collectionView.register(VlogCollectionViewCell.self, forCellWithReuseIdentifier: "vlogCell")
        } else {
            collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "userCell")
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    internal func applyConstraints() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}

// MARK: ProfileCollectionOverviewControllerServiceDelegate
extension ProfileCollectionOverviewViewController: ProfileCollectionOverviewControllerServiceDelegate {
    func didRetrieveItems(_ sender: ProfileCollectionOverviewControllerService) {
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ProfileCollectionOverviewViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == DataType.vlogs {
            return controllerService.vlogs.count
        }
        return controllerService.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        if type == DataType.vlogs {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vlogCell", for: indexPath) as! VlogCollectionViewCell
            let vlog = controllerService.vlogs[indexPath.row]
            (cell! as! VlogCollectionViewCell).durationLabel.text = vlog.duration
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCollectionViewCell
            let user = controllerService.users[indexPath.row]
            (cell! as! UserCollectionViewCell).usernameLabel.text = user.username
        }
        
        return cell!
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProfileCollectionOverviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}
