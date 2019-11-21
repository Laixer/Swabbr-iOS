//
//  ProfileVlogOverviewViewController.swift
//  Swabbr
//
//  Created by James Bal on 02-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// TODO: refactor

import Foundation
import UIKit

class ProfileCollectionOverviewViewController: UIViewController, BaseViewProtocol {
    
    private var collectionView: UICollectionView!
    
    private enum DataType {
        case Following
        case Followers
        case Vlogs
    }
    
    private let type: DataType
    
    private let viewModel = ProfileCollectionOverviewControllerService()
    
    /**
     Initialize the view controller this way if we want to get the vlogs thats associated to the given user id.
     - parameter userId: An int value representing an user id.
    */
    init(vlogOwnerId: Int) {
        type = DataType.Vlogs
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        viewModel.getVlogs(userId: vlogOwnerId)
    }
    
    /**
     Initialize the view controller this way if we want to get the users that the user with this id is currently following.
     - parameter userId: An int value representing an user id.
     */
    init(followingOwnerId: Int) {
        type = DataType.Following
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     Initialize the view controller this way if we want to get the users who is currently following the user with this id.
     - parameter userId: An int value representing an user id.
     */
    init(followersOwnerId: Int) {
        type = DataType.Followers
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        viewModel.getFollowers(userId: followersOwnerId)
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
        
        if type == DataType.Vlogs {
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

extension ProfileCollectionOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == DataType.Vlogs {
            return viewModel.vlogs.count
        }
        return viewModel.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        if type == DataType.Vlogs {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vlogCell", for: indexPath) as! VlogCollectionViewCell
            let vlog = viewModel.vlogs[indexPath.row]
            (cell! as! VlogCollectionViewCell).durationLabel.text = vlog.duration
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCollectionViewCell
            let user = viewModel.users[indexPath.row]
            (cell! as! UserCollectionViewCell).usernameLabel.text = user.username
        }
        
        return cell!
    }
    
}

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
